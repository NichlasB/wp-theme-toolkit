[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('check', 'create', 'list', 'preview-restore', 'apply-restore', 'closeout')]
    [string]$Command,

    [Parameter(Mandatory = $true)]
    [string]$TargetPath,

    [string]$SnapshotRoot,
    [string]$Archive = 'latest',
    [int]$Limit = 25
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.IO.Compression | Out-Null
Add-Type -AssemblyName System.IO.Compression.FileSystem | Out-Null

function Fail([string]$Message) {
    throw $Message
}

function Resolve-ExistingPath([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        Fail "Path not found: $Path"
    }

    return (Resolve-Path -LiteralPath $Path).Path
}

function Resolve-OrCreateDirectory([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }

    return (Resolve-Path -LiteralPath $Path).Path
}

function Require-SnapshotRoot() {
    if ([string]::IsNullOrWhiteSpace($SnapshotRoot)) {
        Fail 'SnapshotRoot is required for this command.'
    }
}

function Get-TargetSlug([string]$Path) {
    return Split-Path -Path $Path -Leaf
}

function Get-RelativeUnixPath([string]$BasePath, [string]$FullPath) {
    $normalizedBase = $BasePath.TrimEnd([System.Char[]]@('\', '/'))

    if (-not $FullPath.StartsWith($normalizedBase, [System.StringComparison]::OrdinalIgnoreCase)) {
        Fail "Cannot derive relative path for '$FullPath' from '$BasePath'."
    }

    $relativePath = $FullPath.Substring($normalizedBase.Length).TrimStart([System.Char[]]@('\', '/'))
    return ($relativePath -replace '\\', '/')
}

function New-TemporaryDirectory([string]$Prefix) {
    $directoryPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ($Prefix + '-' + [System.Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $directoryPath -Force | Out-Null
    return $directoryPath
}

function Get-TargetHeaderInfo([string]$Path) {
    $headerInfo = [ordered]@{
        TargetName    = 'Unknown'
        TargetType    = 'generic-folder'
        Version       = 'Unknown'
        MainEntryFile = 'Unknown'
    }

    $styleCssPath = Join-Path -Path $Path -ChildPath 'style.css'

    if (Test-Path -LiteralPath $styleCssPath) {
        $lines = Get-Content -LiteralPath $styleCssPath -TotalCount 120
        $themeNameLine = $lines | Where-Object { $_ -match 'Theme Name:\s*(.+)$' } | Select-Object -First 1

        if ($themeNameLine) {
            $versionLine = $lines | Where-Object { $_ -match 'Version:\s*(.+)$' } | Select-Object -First 1

            $headerInfo.TargetName = ($themeNameLine -replace '^.*Theme Name:\s*', '').Trim()
            $headerInfo.TargetType = 'theme'
            $headerInfo.Version = if ($versionLine) { ($versionLine -replace '^.*Version:\s*', '').Trim() } else { 'Unknown' }
            $headerInfo.MainEntryFile = 'style.css'

            return [PSCustomObject]$headerInfo
        }
    }

    $rootPhpFiles = Get-ChildItem -LiteralPath $Path -File -Filter '*.php' -Force | Sort-Object Name

    foreach ($phpFile in $rootPhpFiles) {
        $lines = Get-Content -LiteralPath $phpFile.FullName -TotalCount 80
        $pluginNameLine = $lines | Where-Object { $_ -match 'Plugin Name:\s*(.+)$' } | Select-Object -First 1

        if (-not $pluginNameLine) {
            continue
        }

        $versionLine = $lines | Where-Object { $_ -match 'Version:\s*(.+)$' } | Select-Object -First 1

        $headerInfo.TargetName = ($pluginNameLine -replace '^.*Plugin Name:\s*', '').Trim()
        $headerInfo.TargetType = 'plugin'
        $headerInfo.Version = if ($versionLine) { ($versionLine -replace '^.*Version:\s*', '').Trim() } else { 'Unknown' }
        $headerInfo.MainEntryFile = $phpFile.Name
        break
    }

    $projectContextPath = Join-Path -Path $Path -ChildPath '_project-context.md'

    if ($headerInfo.TargetName -eq 'Unknown' -and (Test-Path -LiteralPath $projectContextPath)) {
        $contextLines = Get-Content -LiteralPath $projectContextPath -TotalCount 80
        $projectNameLine = $contextLines | Where-Object { $_ -match '^-\s*Project Name:\s*(.+)$' } | Select-Object -First 1

        if ($projectNameLine) {
            $headerInfo.TargetName = ($projectNameLine -replace '^\-\s*Project Name:\s*', '').Trim()
            $headerInfo.TargetType = 'site-project'
            $headerInfo.MainEntryFile = '_project-context.md'
        }
    }

    return [PSCustomObject]$headerInfo
}

function Get-GitInfo([string]$Path) {
    $gitInfo = [ordered]@{
        GitAvailable       = $false
        IsRepository       = $false
        RepositoryRoot     = 'N/A'
        Branch             = 'N/A'
        Commit             = 'N/A'
        WorktreeState      = 'not-a-repo'
        ModifiedCount      = 0
        DeletedCount       = 0
        UntrackedCount     = 0
        RenamedCount       = 0
        CheckpointEligible = $false
    }

    $gitCommand = Get-Command git -ErrorAction SilentlyContinue

    if (-not $gitCommand) {
        return [PSCustomObject]$gitInfo
    }

    $gitInfo.GitAvailable = $true

    try {
        $repositoryRoot = (& git -C $Path rev-parse --show-toplevel 2>$null).Trim()
    }
    catch {
        return [PSCustomObject]$gitInfo
    }

    if ([string]::IsNullOrWhiteSpace($repositoryRoot)) {
        return [PSCustomObject]$gitInfo
    }

    $gitInfo.IsRepository = $true
    $gitInfo.RepositoryRoot = $repositoryRoot
    $gitInfo.Branch = (& git -C $Path branch --show-current 2>$null).Trim()
    $gitInfo.Commit = (& git -C $Path rev-parse HEAD 2>$null).Trim()

    $statusLines = @(& git -C $Path status --porcelain=v1 --untracked-files=all 2>$null)

    foreach ($statusLine in $statusLines) {
        if ([string]::IsNullOrWhiteSpace($statusLine)) {
            continue
        }

        $statusCode = $statusLine.Substring(0, 2)

        if ($statusCode -eq '??') {
            $gitInfo.UntrackedCount++
            continue
        }

        if ($statusCode.Contains('R')) {
            $gitInfo.RenamedCount++
            continue
        }

        if ($statusCode.Contains('D')) {
            $gitInfo.DeletedCount++
            continue
        }

        $gitInfo.ModifiedCount++
    }

    $changeCount = $gitInfo.ModifiedCount + $gitInfo.DeletedCount + $gitInfo.UntrackedCount + $gitInfo.RenamedCount
    $gitInfo.WorktreeState = if ($changeCount -eq 0) { 'clean' } else { 'dirty' }
    $gitInfo.CheckpointEligible = $gitInfo.IsRepository -and $changeCount -eq 0

    return [PSCustomObject]$gitInfo
}

function Get-SnapshotTargetDirectory([string]$RootPath, [string]$Slug) {
    return Join-Path -Path $RootPath -ChildPath $Slug
}

function Get-SnapshotArchives([string]$SnapshotDirectory) {
    if (-not (Test-Path -LiteralPath $SnapshotDirectory)) {
        return @()
    }

    return [object[]](Get-ChildItem -LiteralPath $SnapshotDirectory -File -Filter '*.zip' | Sort-Object Name -Descending)
}

function Resolve-ArchiveSelection([string]$SnapshotDirectory, [string]$ArchiveSelection) {
    if (-not [string]::IsNullOrWhiteSpace($ArchiveSelection) -and $ArchiveSelection -ne 'latest') {
        if (Test-Path -LiteralPath $ArchiveSelection) {
            return (Resolve-Path -LiteralPath $ArchiveSelection).Path
        }

        $candidatePaths = @(
            (Join-Path -Path $SnapshotDirectory -ChildPath $ArchiveSelection),
            (Join-Path -Path $SnapshotDirectory -ChildPath ($ArchiveSelection + '.zip'))
        )

        foreach ($candidatePath in $candidatePaths) {
            if (Test-Path -LiteralPath $candidatePath) {
                return (Resolve-Path -LiteralPath $candidatePath).Path
            }
        }

        Fail "Restore point not found: $ArchiveSelection"
    }

    $archives = @(Get-SnapshotArchives -SnapshotDirectory $SnapshotDirectory)

    if ($archives.Count -eq 0) {
        Fail "No restore points found in $SnapshotDirectory"
    }

    return $archives[0].FullName
}

function New-ZipFromDirectory([string]$SourcePath, [string]$ArchivePath) {
    if (Test-Path -LiteralPath $ArchivePath) {
        Remove-Item -LiteralPath $ArchivePath -Force
    }

    $resolvedSourcePath = Resolve-ExistingPath -Path $SourcePath
    $zipArchive = [System.IO.Compression.ZipFile]::Open($ArchivePath, [System.IO.Compression.ZipArchiveMode]::Create)

    try {
        $directories = Get-ChildItem -LiteralPath $resolvedSourcePath -Recurse -Force -Directory | Sort-Object FullName

        foreach ($directory in $directories) {
            $directoryEntry = Get-RelativeUnixPath -BasePath $resolvedSourcePath -FullPath $directory.FullName

            if ([string]::IsNullOrWhiteSpace($directoryEntry)) {
                continue
            }

            $zipArchive.CreateEntry($directoryEntry.TrimEnd('/') + '/') | Out-Null
        }

        $files = Get-ChildItem -LiteralPath $resolvedSourcePath -Recurse -Force -File | Sort-Object FullName

        foreach ($file in $files) {
            $entryName = Get-RelativeUnixPath -BasePath $resolvedSourcePath -FullPath $file.FullName
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
                $zipArchive,
                $file.FullName,
                $entryName,
                [System.IO.Compression.CompressionLevel]::Optimal
            ) | Out-Null
        }
    }
    finally {
        $zipArchive.Dispose()
    }
}

function Expand-ZipToDirectory([string]$ArchivePath, [string]$DestinationPath) {
    if (Test-Path -LiteralPath $DestinationPath) {
        Remove-Item -LiteralPath $DestinationPath -Recurse -Force
    }

    New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
    [System.IO.Compression.ZipFile]::ExtractToDirectory($ArchivePath, $DestinationPath)
}

function Test-FilesDifferent([string]$LeftPath, [string]$RightPath) {
    $leftItem = Get-Item -LiteralPath $LeftPath
    $rightItem = Get-Item -LiteralPath $RightPath

    if ($leftItem.Length -ne $rightItem.Length) {
        return $true
    }

    $leftHash = (Get-FileHash -LiteralPath $LeftPath -Algorithm SHA256).Hash
    $rightHash = (Get-FileHash -LiteralPath $RightPath -Algorithm SHA256).Hash

    return $leftHash -ne $rightHash
}

function Get-DirectoryFileMap([string]$RootPath) {
    $fileMap = @{}
    $resolvedRootPath = Resolve-ExistingPath -Path $RootPath
    $files = Get-ChildItem -LiteralPath $resolvedRootPath -Recurse -Force -File

    foreach ($file in $files) {
        $fileMap[(Get-RelativeUnixPath -BasePath $resolvedRootPath -FullPath $file.FullName)] = $file.FullName
    }

    return $fileMap
}

function Compare-ArchiveToTarget([string]$ArchivePath, [string]$TargetRootPath) {
    $stagingDirectory = New-TemporaryDirectory -Prefix 'restore-point-stage'

    try {
        Expand-ZipToDirectory -ArchivePath $ArchivePath -DestinationPath $stagingDirectory

        $snapshotFiles = Get-DirectoryFileMap -RootPath $stagingDirectory
        $currentFiles = Get-DirectoryFileMap -RootPath $TargetRootPath

        $restoreOnly = New-Object System.Collections.Generic.List[string]
        $replace = New-Object System.Collections.Generic.List[string]
        $delete = New-Object System.Collections.Generic.List[string]

        foreach ($relativePath in ($snapshotFiles.Keys | Sort-Object)) {
            if (-not $currentFiles.ContainsKey($relativePath)) {
                $restoreOnly.Add($relativePath)
                continue
            }

            if (Test-FilesDifferent -LeftPath $snapshotFiles[$relativePath] -RightPath $currentFiles[$relativePath]) {
                $replace.Add($relativePath)
            }
        }

        foreach ($relativePath in ($currentFiles.Keys | Sort-Object)) {
            if (-not $snapshotFiles.ContainsKey($relativePath)) {
                $delete.Add($relativePath)
            }
        }

        return [PSCustomObject]@{
            ArchivePath        = $ArchivePath
            StagingDirectory   = $stagingDirectory
            SnapshotFileCount  = $snapshotFiles.Count
            CurrentFileCount   = $currentFiles.Count
            RestoreOnlyFiles   = [string[]]$restoreOnly.ToArray()
            ReplaceFiles       = [string[]]$replace.ToArray()
            DeleteFiles        = [string[]]$delete.ToArray()
        }
    }
    finally {
        if (Test-Path -LiteralPath $stagingDirectory) {
            Remove-Item -LiteralPath $stagingDirectory -Recurse -Force
        }
    }
}

function Write-PreviewReport([string]$Mode, [object]$Report, [int]$MaxItems) {
    $restoreOnlyFiles = @($Report.RestoreOnlyFiles)
    $replaceFiles = @($Report.ReplaceFiles)
    $deleteFiles = @($Report.DeleteFiles)

    Write-Output "MODE=$Mode"
    Write-Output "ARCHIVE_PATH=$($Report.ArchivePath)"
    Write-Output "SNAPSHOT_FILE_COUNT=$($Report.SnapshotFileCount)"
    Write-Output "CURRENT_FILE_COUNT=$($Report.CurrentFileCount)"
    Write-Output "RESTORE_ONLY_COUNT=$($restoreOnlyFiles.Count)"
    Write-Output "REPLACE_COUNT=$($replaceFiles.Count)"
    Write-Output "DELETE_COUNT=$($deleteFiles.Count)"

    $sections = @(
        @{ Title = 'RESTORE_ONLY_FILES'; Items = $restoreOnlyFiles },
        @{ Title = 'REPLACE_FILES'; Items = $replaceFiles },
        @{ Title = 'DELETE_FILES'; Items = $deleteFiles }
    )

    foreach ($section in $sections) {
        Write-Output ''
        Write-Output ($section.Title + ':')

        $items = @($section.Items)

        if ($items.Count -eq 0) {
            Write-Output '- none'
            continue
        }

        foreach ($item in ($items | Select-Object -First $MaxItems)) {
            Write-Output ('- ' + $item)
        }

        if ($items.Count -gt $MaxItems) {
            Write-Output ('- ... ' + ($items.Count - $MaxItems) + ' more')
        }
    }
}

function Write-SidecarFile(
    [string]$SidecarPath,
    [string]$TargetRootPath,
    [string]$ArchivePath,
    [string]$SnapshotDirectory,
    [object]$HeaderInfo,
    [object]$GitInfo,
    [int]$FileCount
) {
    $createdUtc = (Get-Date).ToUniversalTime().ToString('yyyy-MM-dd HH:mm:ss UTC')
    $archiveItem = Get-Item -LiteralPath $ArchivePath
    $archiveHash = (Get-FileHash -LiteralPath $ArchivePath -Algorithm SHA256).Hash

    $sidecarContent = @(
        'Restore Point Metadata',
        '======================',
        '',
        ('Created At: ' + $createdUtc),
        ('Target Folder: ' + (Split-Path -Path $TargetRootPath -Leaf)),
        ('Target Name: ' + $HeaderInfo.TargetName),
        ('Target Type: ' + $HeaderInfo.TargetType),
        ('Version: ' + $HeaderInfo.Version),
        ('Main Entry File: ' + $HeaderInfo.MainEntryFile),
        ('Target Path: ' + $TargetRootPath),
        ('Snapshot Root: ' + $SnapshotRoot),
        ('Snapshot Folder: ' + $SnapshotDirectory),
        ('Archive Path: ' + $ArchivePath),
        ('Archive Size Bytes: ' + $archiveItem.Length),
        ('Archive SHA256: ' + $archiveHash),
        ('Source File Count: ' + $FileCount),
        ('Git Repository: ' + $(if ($GitInfo.IsRepository) { 'Yes' } else { 'No' })),
        ('Git Branch: ' + $GitInfo.Branch),
        ('Git Commit: ' + $GitInfo.Commit),
        ('Worktree State: ' + $GitInfo.WorktreeState),
        '',
        'Notes:',
        '- This is an exact full-folder snapshot of the target path.',
        '- Use preview-restore before apply-restore whenever possible.',
        '- Re-run SESSION_BOOTSTRAP_PROMPT.md after a rollback so chat context matches the restored codebase.'
    )

    Set-Content -LiteralPath $SidecarPath -Value $sidecarContent -Encoding UTF8

    Write-Output "SIDECAR_PATH=$SidecarPath"
    Write-Output "ARCHIVE_SHA256=$archiveHash"
}

function Invoke-RobocopyMirror([string]$SourcePath, [string]$DestinationPath) {
    $null = & robocopy $SourcePath $DestinationPath /MIR /R:1 /W:1 /NFL /NDL /NJH /NJS /NP
    $robocopyExitCode = $LASTEXITCODE

    if ($robocopyExitCode -ge 8) {
        Fail "robocopy failed with exit code $robocopyExitCode"
    }

    Write-Output "ROBOCOPY_EXIT_CODE=$robocopyExitCode"
}

$resolvedTargetPath = Resolve-ExistingPath -Path $TargetPath
$targetSlug = Get-TargetSlug -Path $resolvedTargetPath
$headerInfo = Get-TargetHeaderInfo -Path $resolvedTargetPath
$gitInfo = Get-GitInfo -Path $resolvedTargetPath

switch ($Command) {
    'check' {
        $snapshotDirectory = if ([string]::IsNullOrWhiteSpace($SnapshotRoot)) {
            'N/A'
        }
        else {
            Get-SnapshotTargetDirectory -RootPath $SnapshotRoot -Slug $targetSlug
        }

        $latestArchive = if ($snapshotDirectory -ne 'N/A' -and (Test-Path -LiteralPath $snapshotDirectory)) {
            (@(Get-SnapshotArchives -SnapshotDirectory $snapshotDirectory) | Select-Object -First 1 | ForEach-Object { $_.FullName })
        }
        else {
            ''
        }

        $fileCount = (Get-ChildItem -LiteralPath $resolvedTargetPath -Recurse -Force -File | Measure-Object).Count

        Write-Output "MODE=check"
        Write-Output "TARGET_PATH=$resolvedTargetPath"
        Write-Output "TARGET_SLUG=$targetSlug"
        Write-Output "TARGET_NAME=$($headerInfo.TargetName)"
        Write-Output "TARGET_TYPE=$($headerInfo.TargetType)"
        Write-Output "TARGET_VERSION=$($headerInfo.Version)"
        Write-Output "MAIN_ENTRY_FILE=$($headerInfo.MainEntryFile)"
        Write-Output "FILE_COUNT=$fileCount"
        Write-Output "SNAPSHOT_ROOT=$SnapshotRoot"
        Write-Output "SNAPSHOT_DIRECTORY=$snapshotDirectory"
        Write-Output "LATEST_ARCHIVE=$latestArchive"
        Write-Output "IS_GIT_REPO=$($gitInfo.IsRepository)"
        Write-Output "GIT_BRANCH=$($gitInfo.Branch)"
        Write-Output "GIT_COMMIT=$($gitInfo.Commit)"
        Write-Output "WORKTREE_STATE=$($gitInfo.WorktreeState)"
        Write-Output "MODIFIED_COUNT=$($gitInfo.ModifiedCount)"
        Write-Output "DELETED_COUNT=$($gitInfo.DeletedCount)"
        Write-Output "UNTRACKED_COUNT=$($gitInfo.UntrackedCount)"
        Write-Output "RENAMED_COUNT=$($gitInfo.RenamedCount)"
        Write-Output "GIT_CHECKPOINT_ELIGIBLE=$($gitInfo.CheckpointEligible)"
        break
    }

    'create' {
        Require-SnapshotRoot
        $resolvedSnapshotRoot = Resolve-OrCreateDirectory -Path $SnapshotRoot
        $snapshotDirectory = Resolve-OrCreateDirectory -Path (Get-SnapshotTargetDirectory -RootPath $resolvedSnapshotRoot -Slug $targetSlug)
        $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $baseName = "$targetSlug-$timestamp"
        $archivePath = Join-Path -Path $snapshotDirectory -ChildPath ($baseName + '.zip')
        $sidecarPath = Join-Path -Path $snapshotDirectory -ChildPath ($baseName + '.txt')
        $fileCount = (Get-ChildItem -LiteralPath $resolvedTargetPath -Recurse -Force -File | Measure-Object).Count

        New-ZipFromDirectory -SourcePath $resolvedTargetPath -ArchivePath $archivePath

        Write-Output 'MODE=create'
        Write-Output "TARGET_PATH=$resolvedTargetPath"
        Write-Output "SNAPSHOT_ROOT=$resolvedSnapshotRoot"
        Write-Output "SNAPSHOT_DIRECTORY=$snapshotDirectory"
        Write-Output "ARCHIVE_PATH=$archivePath"
        Write-Output "FILE_COUNT=$fileCount"
        Write-Output "IS_GIT_REPO=$($gitInfo.IsRepository)"
        Write-Output "GIT_BRANCH=$($gitInfo.Branch)"
        Write-Output "GIT_COMMIT=$($gitInfo.Commit)"
        Write-Output "WORKTREE_STATE=$($gitInfo.WorktreeState)"

        Write-SidecarFile `
            -SidecarPath $sidecarPath `
            -TargetRootPath $resolvedTargetPath `
            -ArchivePath $archivePath `
            -SnapshotDirectory $snapshotDirectory `
            -HeaderInfo $headerInfo `
            -GitInfo $gitInfo `
            -FileCount $fileCount
        break
    }

    'list' {
        Require-SnapshotRoot
        $resolvedSnapshotRoot = Resolve-OrCreateDirectory -Path $SnapshotRoot
        $snapshotDirectory = Get-SnapshotTargetDirectory -RootPath $resolvedSnapshotRoot -Slug $targetSlug
        $archives = @(Get-SnapshotArchives -SnapshotDirectory $snapshotDirectory)

        Write-Output 'MODE=list'
        Write-Output "SNAPSHOT_DIRECTORY=$snapshotDirectory"
        Write-Output "RESTORE_POINT_COUNT=$($archives.Count)"

        foreach ($archiveItem in $archives) {
            $sidecarPath = [System.IO.Path]::ChangeExtension($archiveItem.FullName, '.txt')
            Write-Output ('- ' + $archiveItem.FullName + $(if (Test-Path -LiteralPath $sidecarPath) { ' | sidecar=present' } else { ' | sidecar=missing' }))
        }
        break
    }

    'preview-restore' {
        Require-SnapshotRoot
        $resolvedSnapshotRoot = Resolve-OrCreateDirectory -Path $SnapshotRoot
        $snapshotDirectory = Get-SnapshotTargetDirectory -RootPath $resolvedSnapshotRoot -Slug $targetSlug
        $archivePath = Resolve-ArchiveSelection -SnapshotDirectory $snapshotDirectory -ArchiveSelection $Archive
        $report = Compare-ArchiveToTarget -ArchivePath $archivePath -TargetRootPath $resolvedTargetPath

        Write-PreviewReport -Mode 'preview-restore' -Report $report -MaxItems $Limit
        break
    }

    'apply-restore' {
        Require-SnapshotRoot
        $resolvedSnapshotRoot = Resolve-OrCreateDirectory -Path $SnapshotRoot
        $snapshotDirectory = Get-SnapshotTargetDirectory -RootPath $resolvedSnapshotRoot -Slug $targetSlug
        $archivePath = Resolve-ArchiveSelection -SnapshotDirectory $snapshotDirectory -ArchiveSelection $Archive
        $stagingDirectory = New-TemporaryDirectory -Prefix 'restore-point-apply'

        try {
            Expand-ZipToDirectory -ArchivePath $archivePath -DestinationPath $stagingDirectory

            if (-not (Test-Path -LiteralPath $resolvedTargetPath)) {
                New-Item -ItemType Directory -Path $resolvedTargetPath -Force | Out-Null
            }

            Write-Output 'MODE=apply-restore'
            Write-Output "ARCHIVE_PATH=$archivePath"
            Write-Output "TARGET_PATH=$resolvedTargetPath"

            Invoke-RobocopyMirror -SourcePath $stagingDirectory -DestinationPath $resolvedTargetPath
            Write-Output 'RESTORE_RESULT=success'
        }
        finally {
            if (Test-Path -LiteralPath $stagingDirectory) {
                Remove-Item -LiteralPath $stagingDirectory -Recurse -Force
            }
        }
        break
    }

    'closeout' {
        Require-SnapshotRoot
        $resolvedSnapshotRoot = Resolve-OrCreateDirectory -Path $SnapshotRoot
        $snapshotDirectory = Get-SnapshotTargetDirectory -RootPath $resolvedSnapshotRoot -Slug $targetSlug
        $archivePath = Resolve-ArchiveSelection -SnapshotDirectory $snapshotDirectory -ArchiveSelection 'latest'
        $report = Compare-ArchiveToTarget -ArchivePath $archivePath -TargetRootPath $resolvedTargetPath

        Write-Output "IS_GIT_REPO=$($gitInfo.IsRepository)"
        Write-Output "WORKTREE_STATE=$($gitInfo.WorktreeState)"
        Write-Output "MODIFIED_COUNT=$($gitInfo.ModifiedCount)"
        Write-Output "DELETED_COUNT=$($gitInfo.DeletedCount)"
        Write-Output "UNTRACKED_COUNT=$($gitInfo.UntrackedCount)"
        Write-Output "RENAMED_COUNT=$($gitInfo.RenamedCount)"

        Write-PreviewReport -Mode 'closeout' -Report $report -MaxItems $Limit
        break
    }
}
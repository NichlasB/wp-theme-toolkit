<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Git Operations Prompt

Use this prompt when you need Git help for either:
- the `wp-theme-toolkit/` repository itself
- a Blocksy child-theme repository such as `blocksy-child/`
- another explicitly named WordPress site repository in the same workspace

For child-theme or site targets, treat `d3-guides/GIT_WORKFLOW_GUIDE.md` as the source of truth for what belongs in Git and what stays in the database.

---

## Step 0: Confirm Target Repository

Unless already specified by the user, confirm whether to operate on:
- `wp-theme-toolkit/`
- a target child-theme or site repository such as `blocksy-child/`

If multiple likely child-theme or site repositories exist in the workspace, ask which one to use.

**Note:** This step does not apply to Option B, which auto-detects repositories.

---

## Child Theme Safety Rule

When the target is a child-theme or site repository:

1. Commit only files that are actually present in the repository
2. Never describe Blocksy Customizer settings, WordPress content, uploads, or MB Views stored only in the database as Git-tracked changes
3. If a code change depends on database-only content or settings, call that out explicitly in the final summary

---

## Branch Resolution Rules

Repositories in the workspace may use different primary branches such as `main`, `master`, `develop`, or another custom branch name.

Before performing any workflow that commits, pushes, tags, or releases:

1. Determine the **current local branch**
2. Determine the **remote default branch** for `origin`, when available
3. Apply the following rules:
   - If the user explicitly names a branch, use that branch
   - If the workflow says to push the **current branch**, use the currently checked-out local branch
   - If the workflow is a **release workflow**, prefer the repository's remote default branch unless the user explicitly specifies another branch
4. If the current local branch and the remote default branch differ:
   - For commit-and-push workflows, continue on the current local branch unless the user asked for a different branch
   - For release workflows, pause and clearly report the branch mismatch before proceeding
5. Never assume every repository uses the same default branch name

When reporting results, always include the actual branch used.

---

## Option A: Commit and Push Latest Changes (Single Repo)

1. **Analyze the changes** - Examine all modified, added, and deleted files
2. **Generate a descriptive commit message** following conventional commit format:
   - Use appropriate type: `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`, `chore:`
   - Write a clear, concise subject line of 50 characters or less
   - Include a body with bullet points describing key changes when needed
3. **Stage all changes** with `git add .`
4. **Commit** with the generated message
5. **Push** to the current branch
6. **Report branch context** in the final summary:
   - Current local branch used
   - Remote default branch, if detected
   - Whether they matched

Execute all steps automatically. If there are no changes to commit, inform me.

---

## Option B: Commit and Push All Repositories in Workspace

Perform Option A across every repository in the workspace, one at a time.

### Step 1: Discover Repositories
- Scan the workspace for all directories containing a `.git` folder
- Prefer repositories that clearly match the toolkit repo, a child theme, or another named project root
- List the discovered repositories and confirm with the user before proceeding

### Step 2: Process Each Repository
For each discovered repository, one at a time:
1. `cd` into the project directory
2. Check for uncommitted changes with `git status`
3. If **no changes exist**, skip this repo and note it in the summary
4. If **changes exist**, execute the full Option A workflow:
   - Analyze changes
   - Generate a descriptive conventional commit message
   - Stage all changes with `git add .`
   - Commit with the generated message
   - Push to the current branch
   - Record both the current local branch and the remote default branch, if detected

### Step 3: Summary Report
After all repositories have been processed, present a summary table:

```text
| Repository       | Status     | Commit Message              | Branch  |
|------------------|------------|-----------------------------|---------|
| wp-theme-toolkit | Pushed     | docs: add theme git prompt  | main    |
| blocksy-child    | Skipped    | No changes                  | main    |
```

Include:
- Total repositories found
- Total pushed
- Total skipped because no changes were present
- Any errors encountered

---

## Option C: Release Workflow (Toolkit Or Child Theme)

Perform a release workflow for the selected repository.

### Step 1: Analyze Changes Since Last Release
- Resolve branch context before making changes:
  - Detect the current local branch
  - Detect the remote default branch for `origin`, when available
  - If they differ, stop and report the mismatch unless the user explicitly told you which branch to release from
- Run `git log --oneline` from the last tag to `HEAD`
- Categorize all changes such as features, fixes, docs updates, and structural changes
- Identify the appropriate version bump: major, minor, or patch

### Step 2: Detect Repository Type
Classify the repository before updating files:
- **Theme toolkit repo** if it contains `_TASK_RUNNER.md`, `d4-prompts/`, and `d3-guides/`
- **Child-theme repo** if it contains `style.css`, `functions.php`, or folders such as `mb-json/`, `views/`, or `inc/`
- **Generic repo fallback** if neither pattern clearly matches

### Step 3: Update Versioned Files Conservatively
Update only version markers or release files that already exist and clearly belong to the detected repository type.

For a **theme toolkit repo**:
- update `CHANGELOG.md`
- update version references in `README.md` or `readme.txt` only if they already exist
- do not invent new version headers solely for release automation

For a **child-theme repo**:
- update the `Version:` field in `style.css` if present
- update any clearly named existing version constant in `functions.php` or related bootstrap files if present
- update `readme.txt` `Stable tag:` if the file exists
- never claim database-only content as part of the Git release payload

For a **generic repo fallback**:
- update only files that already contain obvious release or version markers
- if no version markers exist, stop after drafting release notes and ask whether a tag-only release is acceptable

### Step 4: Generate Release Information
Provide:

**Release Title:**
`vX.X.X - [Brief descriptive title based on main changes]`

**Release Description:**
```markdown
## What's New in vX.X.X

[2-3 sentence summary of this release]

### Highlights
- Key change 1
- Key change 2
- Key change 3

### Changelog
[Copy of the CHANGELOG.md entry or equivalent release summary]

### Upgrade Notes
[Important upgrade notes, or "No breaking changes in this release."]
```

### Step 5: Human Approval Checkpoint
Before committing, tagging, pushing, or publishing the release, present the following for approval:
- Proposed version: `vX.X.X`
- Release title
- Release description
- Upgrade notes

Ask for explicit approval using a clear prompt such as:
- `Approve release`
- or requested changes

Do **not** continue until explicit approval is received.

### Step 6: Commit All Changes
Create a release commit with message:

```text
chore(release): bump version to X.X.X

- Update version references where applicable
- Update changelog or release notes
- Prepare tag and release metadata
```

### Step 7: Create Git Tag
- Create annotated tag: `git tag -a vX.X.X -m "Release vX.X.X"`

### Step 8: Push Everything
- Push commits: `git push origin [release-branch]`
- Push tags: `git push origin vX.X.X`

### Step 9: Create And Publish GitHub Release
- Before concluding that GitHub CLI `gh` is unavailable, first check whether it is on `PATH`
- On Windows, if `gh` is not on `PATH`, also check these common install locations:
  - `C:\Program Files\GitHub CLI\gh.exe`
  - `C:\Program Files (x86)\GitHub CLI\gh.exe`
  - `%LOCALAPPDATA%\Programs\GitHub CLI\gh.exe`
- If `gh` is found outside `PATH`, use the full executable path for subsequent release commands in the current task
- If GitHub CLI is available and authenticated, create the GitHub release from the new tag
- Publish the release immediately using the approved release title and release description
- Prefer `gh release create` so the process is fully automated
- If GitHub CLI is unavailable or authentication fails, stop and tell me exactly what manual step remains

### Step 10: Summary
Present a final summary with:
- Repository path released
- Repository type detected
- All files modified
- New version number
- Release branch used
- Remote default branch detected
- Git tag created
- Release title and description used for the GitHub release
- GitHub release URL, if created
- Any database-only follow-up items that are intentionally outside Git

Execute all steps automatically, except for the mandatory approval checkpoint in Step 5.

---

## Option D: Dry Run (Preview Only)

Analyze the selected repository and show what a release would look like without making any changes:

1. Show all changes since the last git tag
2. Suggest the appropriate version bump with reasoning
3. Draft the changelog or release-notes entry
4. Draft the release title and description
5. List all files that would need version or release-note updates

Do not modify files and do not create tags in this option.

---

## Modifiers

These can be added to the request:

| Modifier | Example Usage |
|----------|---------------|
| Specific target repo | `Run Option A on blocksy-child` |
| Specific branch | `Run Option A and push to develop` |
| Explicit version | `Run Option C and use version 1.2.0` |
| Stop before GitHub release | `Run Option C but stop after tag creation` |

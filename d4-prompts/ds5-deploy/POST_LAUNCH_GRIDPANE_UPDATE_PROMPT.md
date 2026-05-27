<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Post-Launch GridPane Update Workflow

Use this prompt when a Meta Views Stack site already exists on GridPane and you need to push a smaller follow-up update from LocalWP or a child-theme repository.

This workflow is for incremental staging or production updates after the first launch.

It is a post-launch deployment workflow, not a first-launch bootstrap workflow.

---

## Purpose

Run this when the target site is already present on GridPane and the next change is one of these:
- code only
- code plus uploads
- code plus selected database or content changes
- an approved full refresh of staging

Use it to:
- classify the update before touching the server
- protect live production data from unnecessary overwrite
- choose the smallest safe deployment path
- decide whether to deploy the child theme through Git or through a clean deployment copy
- exclude obvious non-runtime child-theme files when a clean deployment copy is requested
- validate the deployed result and report any remaining manual checks

Default stance:
- treat any GridPane target, including staging, as production-like for deploy hygiene
- prefer a production-ready deployment payload over mirroring the full LocalWP working tree

Do not use this workflow for the first LocalWP to GridPane launch. Use `GRIDPANE_DEPLOYMENT_PROMPT.md` for that.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `d1-setup/STACK_REFERENCE.md`
- `d3-guides/GIT_WORKFLOW_GUIDE.md`
- `DEPLOYMENT_CHECKLIST.md`

Treat `GIT_WORKFLOW_GUIDE.md` as the source of truth for the code-versus-content split.

Shared default for LocalWP to GridPane database export:
- use LocalWP's bundled `mysqldump`
- use `--result-file`
- do not use PowerShell `>` redirection
- do not use `--databases local` when the dump is intended for GridPane import

Treat that export pattern as the default unless the project-specific deployment context file documents an explicit override.

---

## Required Inputs

If the user has not already provided them, gather these inputs first from the project-specific deployment context file or from the user:
- target site project or child-theme path
- target environment: staging or production
- target domain and GridPane site path
- change class: code only, code plus uploads, code plus selected DB/content, or full refresh
- deploy preference: Git-first, clean archive deploy, migration plugin, or manual server steps
- whether the target already contains live user or editor data that must not be overwritten
- whether a clean deployment copy is desired
- access availability: SSH, WordPress admin, Git access, database access

Helpful optional inputs:
- whether a restore point already exists for the target
- whether the update should sync uploads fully or only for a narrow scope
- whether a reverse pull from GridPane back to LocalWP is expected after the work
- a project-specific DB export override, only when the default LocalWP to GridPane export method does not apply

---

## Required Outputs

During this workflow, create or report:

1. a concise deployment log entry in chat
2. the selected update class and deploy path
3. the clean-copy exclusion list when clean deployment mode is used
4. blockers or manual follow-up items when needed

This workflow does not update `DEPLOYMENT_CHECKLIST.md` by default because it is for post-launch incremental updates rather than the first-launch phase tracker.

## Command Formatting Rule

When providing user-facing commands to run:

- use single-line commands only
- wrap commands in fenced code blocks
- do not split a single command across multiple lines with continuation characters
- if a step requires multiple commands, present them as separate single-line commands in execution order

Prioritize copy-paste reliability for PowerShell and SSH sessions over visual formatting.

---

## Site Context Bootstrap

Before asking broad deployment questions, check for a project-specific deployment context file.

Canonical path for Meta Views Stack child-theme projects:
- `[child-theme-root]/gridpane-deploy-context.md`

Bootstrap behavior:
- if the file exists, read it first and use it as the primary source for site-specific deployment facts
- if the file is missing, ask the user only for the site-specific fields listed below, then create it before continuing
- if the file exists but is incomplete, ask only for the missing site-specific fields, update it, then continue
- do not ask for the shared LocalWP to GridPane DB export method unless this project needs an override

Required site-specific fields:
- project name
- LocalWP site name
- local child-theme path
- production domain
- GridPane SSH alias
- GridPane site root
- server child-theme path
- whether staging exists and, if so, its domain and site root
- required post-deploy check pages
- project-specific deployment gotchas or validation notes

Optional site-specific fields:
- DB export override, only if this project cannot use the shared default LocalWP to GridPane export method
- preferred rollback naming convention if the project uses a special pattern
- plugin or feature dependencies that must be checked after deploy

When asking the user for missing site-specific fields, include a filled sample template so they can see the expected format immediately.

Sample filled template:

```text
Project Name: Example Wellness TV
LocalWP Site Name: example-wellness-tv
Local Child Theme Path: C:\Users\Captain\Local Sites\example-wellness-tv\app\public\wp-content\themes\blocksy-child
Production Domain: https://examplewellness.com
GridPane SSH Alias: example-1
GridPane Site Root: /var/www/examplewellness.com/htdocs
Server Child Theme Path: /var/www/examplewellness.com/htdocs/wp-content/themes/blocksy-child
Staging Exists: yes
Staging Domain: https://staging.examplewellness.com
Staging Site Root: /var/www/staging.examplewellness.com/htdocs
Required Post-Deploy Check Pages:
- /
- /library/
- /video/sample-video/
- /my-account/
Project-Specific Deployment Gotchas or Validation Notes:
- Check that the Blocksy parent theme remains installed and active as the template
- Validate one representative video page and one account page after every DB import
DB Export Override: none
Preferred Rollback Naming Convention: blocksy-child-before-refresh-YYYYMMDD-HHMM
Plugin or Feature Dependencies to Check:
- Presto Player
- Meta Box AIO
- SureForms
```

When creating or updating `gridpane-deploy-context.md`, keep it concise and operational.

---

## Change Classification

Choose one primary update class before any server mutation:

### 1. Code only

Use this when the update is limited to child-theme code or other file-backed code changes such as:
- `style.css`
- `functions.php`
- `inc/`
- `assets/`
- `views/` local reference copies
- tracked `mb-json/` artifacts
- page template PHP files

Preferred path:
- Git deploy when the repo is already production-safe
- clean archive deploy when the repo contains tracked non-runtime files the user does not want on the server

### 2. Code plus uploads

Use this when code changed and the site also needs new or replaced media files.

Preferred path:
- deploy code first
- then sync uploads with the smallest safe file transfer method

### 3. Code plus selected DB or content changes

Use this when code changed and the site also needs database-backed content or settings moved from LocalWP.

Preferred path:
- deploy code first
- then migrate only the required DB or content slice when possible
- avoid full production DB replacement unless explicitly approved

### 4. Full refresh

Use this only when the target is disposable staging or the user explicitly approves a full refresh.

Preferred path:
- restore point first
- full database and uploads replacement only after the user confirms the overwrite risk

---

## Clean Deployment Copy Rules

When deploying to GridPane, default to a clean deployment copy unless the user explicitly asks to deploy the tracked theme tree as-is.

Treat GridPane staging with the same deploy-hygiene standard as production. Do not ship planning files, migration runbooks, or maintenance utilities by default just because the target is staging.

When clean deployment mode is active, include runtime child-theme files and exclude obvious non-runtime files.

If a child-theme `.distignore` file exists, use it as the baseline exclusion rule for the clean deployment copy, then report any additional one-off exclusions added for the current task.

### Keep by default

- `style.css`
- `functions.php`
- `assets/`
- `inc/`
- `views/`
- `mb-json/`
- page template PHP files
- `screenshot.jpg`

### Exclude by default when present

- `.git/`
- `.github/`
- `.cursor/`
- `.vscode/`
- `.idea/`
- `.gitignore`
- `.gitattributes`
- `*.tmp.md`
- `session-context.tmp.md`
- `session-handoff.tmp.md`
- `_project-context.md`
- `video-library-migration/`
- `tools/`
- planning or operator notes that are not runtime assets
- migration-only runbooks and execution notes that are not runtime assets

### Include only after explicit approval

- maintenance-only helper scripts that the user deliberately wants available on the server for a one-off operation
- project documentation or planning files the user explicitly wants deployed
- migration support folders the user explicitly wants present on the target for a narrow operator task

If there is uncertainty about whether a file is runtime-relevant, keep it and report the uncertainty instead of silently excluding it.

---

## Execution Phases

### Phase 0: Load or bootstrap site context

- resolve the target child-theme path first
- check for `[child-theme-root]/gridpane-deploy-context.md`
- read it before proposing commands when it exists
- if it is missing or incomplete, collect only the missing site-specific fields, show the filled sample template, then create or update the file before continuing
- treat the LocalWP to GridPane DB export method as a shared default unless the context file explicitly overrides it

### Phase 1: Confirm target risk

- confirm the exact GridPane site path and environment
- confirm whether the target contains live user or editor data
- block any full production DB overwrite unless the user explicitly approves it

### Phase 2: Classify the change

- choose the smallest matching update class
- explain why that class was selected
- recommend the default deploy path and keep alternatives brief

### Phase 3: Inspect local deploy surface

- inspect the child-theme repository or target path
- check whether the repo is clean enough for a Git deploy
- if clean-copy mode is requested, load `.distignore` when present and build the final exclusion list before any packaging or transfer

### Phase 4: Deploy code

Choose one path:

- Git path: commit or verify the needed code, push, then SSH and `git pull`
- clean archive path: package only the approved runtime files, upload, extract, and normalize ownership and permissions

Do not describe database-only changes as Git-tracked deployment work.

### Phase 5: Optional uploads sync

- run this only when uploads are part of the approved change class
- prefer one archive plus server-side extract for larger transfer sets
- prefer narrow sync when only a subset of uploads changed

### Phase 6: Optional DB or content step

- run this only when the approved change class includes DB or content work
- use the smallest safe migration path that fits the request
- run URL search-replace when the source and target domains differ

### Phase 7: Normalize server state

- fix file ownership when archive extraction or manual upload created `root`-owned files
- fix permissions when extracted files are too broad
- flush rewrite rules when routes or CPT behavior may have changed

### Phase 8: Validate

At minimum, check:
- expected active theme
- expected plugins needed for the deployed slice
- representative public pages or routes
- manual follow-up checks still needed in the browser

---

## Common Pitfalls

- treating a production update like a fresh launch and overwriting live data unnecessarily
- pushing docs, temp notes, or migration runbooks to the server just because they are tracked in Git
- using Git to represent database-backed content changes
- forgetting that the child theme may depend on the Blocksy parent theme and required plugins already being present
- leaving extracted files owned by `root` after archive deployment
- skipping search-replace after DB import or partial content migration
- assuming a plugin-based migration failure means the code deploy surface is wrong

---

## Output Format

Report the result in this structure:

```text
Target project: [name]
Environment: [staging / production]
GridPane path: [path]
Change class: [code only / code + uploads / code + selected DB-content / full refresh]
Deploy path: [Git / clean archive / migration plugin / manual]
Clean-copy mode: [on / off]
Excluded from clean copy:
- [item or none]
Code deploy: [done / blocked / not needed]
Uploads step: [done / blocked / not needed]
DB-content step: [done / blocked / not needed]
Validation:
- [check result]
Open issues:
- [issue or none]
Next action: [short recommendation]
```

Keep the output concise and operational.

---

## Final Assistant Output

After the update work is complete, report:
- the exact target project and environment used
- the selected update class
- the deploy path used
- whether clean deployment mode was used and which exclusions mattered
- which phases completed and which were skipped or blocked
- the most relevant next action

Proceed with the post-launch update workflow now.
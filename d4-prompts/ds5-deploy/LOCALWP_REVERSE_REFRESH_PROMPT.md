<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# LocalWP Reverse Refresh Workflow

Use this prompt when a Meta Views Stack site already exists on GridPane and the matching LocalWP site needs fresh database content, settings, or uploads from staging or production.

This workflow pulls content back to LocalWP. It is not a deployment workflow and must never mutate the GridPane source site.

---

## Purpose

Run this when local development needs to match current GridPane content before new code work, QA, troubleshooting, or post-launch refinement.

Use it to:
- pull a GridPane staging or production database into the matching LocalWP site
- review likely local-only database changes before replacing the LocalWP database
- run source-domain to LocalWP-domain search-replace after import
- copy missing remote uploads into the local uploads folder
- validate the refreshed LocalWP state before continuing site work

Default mode:
- database and missing uploads

Default stance:
- GridPane is the read-only source
- LocalWP is the only target
- local database change review is read-only and does not merge data
- existing local uploads are preserved
- code still moves through Git and the existing deployment workflows

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `d1-setup/LOCALWP_DATABASE_ACCESS_WORKFLOW.md`
- `d3-guides/GIT_WORKFLOW_GUIDE.md`
- `d4-prompts/ds5-deploy/GRIDPANE_DEPLOYMENT_PROMPT.md`
- `d4-prompts/ds5-deploy/POST_LAUNCH_GRIDPANE_UPDATE_PROMPT.md`

Treat `LOCALWP_DATABASE_ACCESS_WORKFLOW.md` as the source of truth for LocalWP MySQL access on Windows.

Treat `GIT_WORKFLOW_GUIDE.md` as the source of truth for the code-versus-content split.

---

## Supported Modifiers

The user may add these modifiers:
- `from production`
- `from staging`
- `uploads only`
- `database only`
- `database and missing uploads`
- `preview only`
- `allow overwrite uploads`
- `review local changes only`

If no mode is specified, use `database and missing uploads`.

`allow overwrite uploads` changes only the uploads step. It does not permit deleting local uploads or syncing code.

`review local changes only` runs the local pre-refresh database review and stops before backup, import, search-replace, or uploads transfer.

---

## Required Inputs

If the user has not already provided them, gather these inputs first from `gridpane-deploy-context.md` or from the user:
- target site project or child-theme path
- source environment: staging or production
- source domain
- GridPane SSH alias
- GridPane site root
- LocalWP site name
- LocalWP domain
- LocalWP web root
- whether database, uploads, or both should be refreshed
- whether this is preview only
- whether local database change review should stop on likely local-only changes

Optional inputs:
- project-specific remote DB export override
- project-specific LocalWP DB import override
- required post-refresh check pages
- whether uploads overwrite is explicitly approved

Before asking broad questions, check for:
- `[child-theme-root]/gridpane-deploy-context.md`

If the context file exists, read it first and use it as the primary source for site-specific facts.

---

## Hard Safety Rules

- Never mutate the GridPane source.
- Never import into production from this workflow.
- Never run a full LocalWP database replacement without first creating a local DB dump.
- Never use PowerShell `>` for database dumps; use `--result-file`.
- Never use `--delete` for uploads sync by default.
- Never delete local uploads from this workflow.
- Never sync themes, plugins, WordPress core, workflow notes, migration notes, or code files.
- Never treat reverse refresh as code deployment.
- Never auto-merge LocalWP database changes with GridPane database changes.
- Never treat local change review as proof that no local-only database edits exist.
- Block if the LocalWP target cannot be confidently matched to the source site.
- Block if the source and target paths indicate the same environment.

---

## Command Formatting Rule

When providing user-facing commands to run:

- use single-line commands only
- wrap commands in fenced code blocks
- do not split a single command across multiple lines with continuation characters
- if a step requires multiple commands, present them as separate single-line commands in execution order

Prioritize copy-paste reliability for PowerShell and SSH sessions over visual formatting.

---

## Execution Phases

### Phase 0: Load site context

- resolve the target child-theme path first
- read `[child-theme-root]/gridpane-deploy-context.md` when present
- identify source environment, source domain, GridPane SSH alias, GridPane site root, LocalWP site name, LocalWP domain, and LocalWP web root
- confirm the target is LocalWP and the source is GridPane
- if the context is missing or incomplete, ask only for the missing site-specific fields

### Phase 1: Classify refresh mode

Choose one primary mode:
- database and missing uploads
- database only
- uploads only
- preview only
- review local changes only

If the user requested uploads overwrite, record that approval explicitly.

If no mode is specified, use database and missing uploads.

### Phase 2: Preview and risk check

- show the selected source environment and LocalWP target
- confirm the database import will replace the LocalWP database when database refresh is active
- confirm the local database change review is read-only and cannot merge local edits
- confirm uploads default to missing-only copy
- confirm no code files will be synced
- inspect or report the local and remote uploads paths

If `preview only` is requested, stop after this phase and report the planned commands or steps without changing anything.

### Phase 3: Review likely local database changes

Run this when database refresh is active or when `review local changes only` is requested.

This phase is read-only. It helps avoid burying local database work under the live/staging import, but it is not a merge tool and cannot prove that every local-only change has been found.

Use LocalWP's bundled `mysql.exe` and run a concise local review that includes:
- current `siteurl` and `home`
- recent posts and pages ordered by `post_modified`
- recent `wp_posts` rows for likely database-backed builder or placement types, including `ct_content_block`, `mb-views`, and other project-relevant custom post types when detectable
- recent attachments ordered by `post_date` or `post_modified`
- counts for posts, pages, attachments, and relevant custom post types
- active theme and active plugin option values when practical
- recently updated options only when the project stores reliable timestamps; otherwise state that `wp_options` has no normal modified timestamp

If the review shows likely local-only or recently changed content that may matter:
- summarize the findings
- explain that the upcoming database import will replace the LocalWP database
- stop and ask for explicit approval before continuing

If the user requested `review local changes only`, stop after reporting the review.

Do not try to preserve selected rows, merge options, or reconcile serialized values automatically.

### Phase 4: Create LocalWP database backup

Run this only when database refresh is active.

- resolve LocalWP database metadata from `sites.json` when needed
- use LocalWP's bundled `mysqldump`
- write the dump with `--result-file`
- store the backup outside the imported dump path, using a timestamped filename
- verify the backup file exists and is non-empty before continuing

Block the database import if backup creation fails.

### Phase 5: Export remote GridPane database

Run this only when database refresh is active.

- connect to the GridPane source over SSH
- run the remote export from the GridPane site root
- prefer WP-CLI export when available
- keep the export file in a temporary or backup-safe remote location
- do not run search-replace on the remote source

Example command shape:

```bash
cd /var/www/example.com/htdocs && wp db export /tmp/example-refresh-YYYYMMDD-HHMM.sql
```

### Phase 6: Transfer remote database dump locally

Run this only when database refresh is active.

- transfer the remote dump to a local temporary or project-operator folder
- keep the source dump separate from the LocalWP backup dump
- verify the transferred dump exists and is non-empty

### Phase 7: Import into LocalWP

Run this only when database refresh is active.

- use LocalWP's bundled `mysql.exe`
- import into the LocalWP database resolved in Phase 3
- do not use generic PHP, `wp-load.php`, or an unrelated MySQL client as the first path
- run a quick post-import query to confirm the database responds

### Phase 8: Run local URL search-replace

Run this when database refresh is active and source and local domains differ.

- prefer local WP-CLI when available
- use precise serialized-data-safe replacement
- replace source domain with LocalWP domain
- verify `siteurl` and `home` after the replacement

If local WP-CLI is not available, block or document the safest project-approved fallback instead of running naive SQL against serialized data.

### Phase 9: Sync missing uploads

Run this when uploads refresh is active.

- source path: remote `wp-content/uploads/`
- target path: LocalWP `wp-content/uploads/`
- default behavior: copy only missing files
- never pass a delete flag
- do not sync `themes/`, `plugins/`, WordPress core, workflow files, or project notes
- if overwrite was explicitly approved, overwrite uploads only and report that approval

For Windows-to-GridPane work, prefer a clear file transfer method that can preserve nested upload paths and produce a count or dry-run summary before treating the sync as complete.

### Phase 10: Validate LocalWP state

At minimum, validate:
- LocalWP database connection
- `siteurl` and `home`
- representative post/page counts
- active theme name
- active plugin list or obvious plugin mismatch warnings
- representative pages listed in context
- a representative media URL or file path
- absence of obvious source-domain leftovers when practical

Plugin or theme parity issues are warnings or blockers for local testing. Do not fix them by syncing code through this workflow.

### Phase 11: Report result

Report completed, skipped, blocked, and manually verified steps using the output format below.

---

## Common Pitfalls

- importing into the wrong LocalWP site because two local site names are similar
- ignoring local database review findings and accidentally replacing local-only content
- assuming the local database review can detect every local-only edit
- skipping the local database backup because LocalWP feels disposable
- trying to merge selected local database rows into the pulled-down GridPane database
- using this workflow to pull production code instead of using Git
- using destructive upload sync flags that delete local files
- overwriting local media when missing-only sync was enough
- corrupting serialized data with naive SQL search-replace
- treating plugin parity warnings as permission to copy plugin folders from production

---

## Output Format

Report the result in this structure:

```text
Target project: [name]
Source environment: [staging / production]
Source domain: [domain]
LocalWP site: [site name]
Local domain: [domain]
Local DB change review: [done / blocked for approval / skipped with reason]
Database backup: [created / blocked / skipped with reason]
Database import: [done / blocked / not requested]
Search-replace: [done / blocked / not needed]
Uploads sync: [missing-only / overwrite-approved / blocked / not requested]
Validation:
- [check result]
Open issues:
- [issue or none]
Next action: [short recommendation]
```

Keep the output concise and operational.

---

## Final Assistant Output

After the reverse refresh work is complete, report:
- the exact source environment and LocalWP target used
- which mode was selected
- whether local database review found likely local-only changes
- where the local database backup was created when applicable
- whether uploads were missing-only or overwrite-approved
- which validations passed
- any blockers or manual checks still needed

Proceed with the LocalWP reverse refresh workflow now.

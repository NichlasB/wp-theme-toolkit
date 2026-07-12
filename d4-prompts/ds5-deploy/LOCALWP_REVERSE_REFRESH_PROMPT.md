<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# LocalWP Reverse Refresh Workflow

Use this prompt when a Meta Views Stack site already exists on GridPane and the matching LocalWP site needs fresh database content, settings, or uploads from staging or production.

This workflow pulls content back to LocalWP. It is not a deployment workflow and must never mutate the GridPane source site.

---

## Purpose

Run this when local development needs to match current GridPane content before new code work, QA, troubleshooting, or post-launch refinement.

Use it to:
- pull a GridPane staging or production database into the matching LocalWP site
- compare live/staging and LocalWP database state before replacing the LocalWP database
- run source-domain to LocalWP-domain search-replace after import
- reconnect local-only MCP/client credentials such as Novamira when the imported database invalidates LocalWP application passwords
- copy missing remote uploads into the local uploads folder
- validate the refreshed LocalWP state before continuing site work

Default mode:
- database and missing uploads

Default stance:
- GridPane is the read-only source
- LocalWP is the only target
- local database comparison is read-only and does not merge data
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
- `preserve local-only tools`
- `skip local-only tool preservation`

If no mode is specified, use `database and missing uploads`.

`allow overwrite uploads` changes only the uploads step. It does not permit deleting local uploads or syncing code.

`review local changes only` runs the local pre-refresh database review and stops before backup, import, search-replace, or uploads transfer.

`preserve local-only tools` snapshots and restores allowlisted LocalWP-only tool/plugin configuration around the database import. When the LocalWP site has Novamira/Novamira Pro installed locally, this preservation is enabled by default unless the user explicitly requests `skip local-only tool preservation`.

Environment plugin activation is reconciled after database refresh even when local-only tool preservation is skipped.

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
- whether source/local database comparison should stop on likely local-only or local-newer changes
- whether local-only tool/plugin configuration should be preserved around the database import
- local plugin activation policy for plugins that differ between GridPane and LocalWP

Optional inputs:
- project-specific remote DB export override
- project-specific LocalWP DB import override
- required post-refresh check pages
- whether uploads overwrite is explicitly approved
- local-only plugin preservation allowlist, if the project uses tools that should exist only in LocalWP
- environment plugin policy allowlist, if the project installs live/staging infrastructure plugins locally only to avoid missing-file warnings
- local AI client MCP config path or reconnect workflow, when a LocalWP-only tool such as Novamira is expected to remain usable after the import

Before asking broad questions, check for:
- `[child-theme-root]/gridpane-deploy-context.md`

If the context file exists, read it first and use it as the primary source for site-specific facts.

---

## Hard Safety Rules

- Never mutate the GridPane source.
- Never import into production from this workflow.
- Never run a full LocalWP database replacement without first creating a local DB dump.
- Never import a WordPress database through a MySQL session that has not explicitly selected `utf8mb4`.
- Never use PowerShell `>` for database dumps; use `--result-file`.
- Never rewrite a SQL dump as text to remove compatibility lines; if a dump must be sanitized, remove only the offending bytes/line with a byte-preserving method.
- Never use `--delete` for uploads sync by default.
- Never delete local uploads from this workflow.
- Never sync themes, plugins, WordPress core, workflow notes, migration notes, or code files.
- Never treat reverse refresh as code deployment.
- Never auto-merge LocalWP database changes with GridPane database changes.
- Never preserve local-only plugin data by broad guessing; use an explicit allowlist.
- Never leave GridPane-only infrastructure plugins active in LocalWP just because they were active in the imported GridPane database.
- Never treat local comparison as proof that no local-only database edits exist.
- Never use naive SQL search-replace for serialized WordPress data.
- Never print, log, commit, or leave behind generated application passwords, MCP bearer tokens, Basic auth snippets, or credential-bearing page inspection files.
- Never run a credential, reconnect, or temporary-admin helper against GridPane, staging, production, or any public URL.
- Never keep a credential reconnect helper as a standing file; create it only on demand in the confirmed LocalWP target, protect it with a random token, make it self-delete, and verify it is gone.
- Never create a temporary administrator account by default. Prefer a new application password for an existing trusted admin user, and require explicit user approval before using a temporary-admin fallback.
- Never leave temporary SQL dumps or helper scripts behind except the required local pre-refresh backup.
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
- when resolving LocalWP metadata from `sites.json`, inspect the actual service object instead of assuming one fixed shape
- support both `services.mysql` and `services.mariadb` records, and read the port from the service's `ports.MYSQL` array when present
- confirm the LocalWP database name, user, password, host, port, web root, and available LocalWP MySQL client before database work
- inspect the LocalWP `wp-config.php` `DB_HOST` value and confirm it points at the resolved LocalWP TCP endpoint, such as `127.0.0.1:{MYSQL_PORT}`, when plugins may open their own PDO or database connections

### Phase 1: Classify refresh mode

Choose one primary mode:
- database and missing uploads
- database only
- uploads only
- preview only
- review local changes only

If the user requested uploads overwrite, record that approval explicitly.

If no mode is specified, use database and missing uploads.

If the LocalWP site has Novamira/Novamira Pro plugin files present and the user has not requested `skip local-only tool preservation`, enable Novamira local-only preservation for database refreshes.

### Phase 2: Preview and risk check

- show the selected source environment and LocalWP target
- confirm the database import will replace the LocalWP database when database refresh is active
- confirm the local-vs-source database comparison is read-only and cannot merge local edits
- confirm uploads default to missing-only copy
- confirm no code files will be synced
- when a LocalWP-only MCP/client tool such as Novamira is expected, confirm whether reconnect is approved if the database import invalidates the current application password, including use of an on-demand self-deleting LocalWP-only helper when needed
- inspect or report the local and remote uploads paths

If `preview only` is requested, stop after this phase and report the planned commands or steps without changing anything.

### Phase 3: Compare source and local database state

Run this when database refresh is active or when `review local changes only` is requested.

This phase is read-only. It helps avoid burying local database work under the live/staging import, but it is not a merge tool and cannot prove that every local-only change has been found.

Use LocalWP's bundled `mysql.exe` for local queries. Use remote WP-CLI over SSH for source queries when available. If the GridPane SSH session runs WP-CLI as root and WP-CLI refuses to run, add `--allow-root` for read-only and export commands only.

Run a concise side-by-side comparison that includes:
- current `siteurl` and `home`
- counts for posts, pages, attachments, and relevant custom post types on both source and local
- recent pages on both source and local, ordered by `post_modified`
- recent attachments on both source and local, ordered by `post_date` or `post_modified`
- recent `wp_posts` rows for likely database-backed builder or placement types, including `ct_content_block`, `mb-views`, and other project-relevant custom post types when detectable
- active theme and active plugin option values on both source and local when practical
- local-only active plugins that exist in LocalWP but not on GridPane, especially development tools such as Novamira or Novamira Pro
- GridPane-only infrastructure plugins that should be inactive in LocalWP even if active on the source
- recently updated options only when the project stores reliable timestamps; otherwise state that `wp_options` has no normal modified timestamp

Report the comparison in terms of:
- local-only or local-newer content
- source-only or source-newer content
- count differences that will be resolved by replacing the LocalWP database
- plugin or theme count/parity warnings that may affect local testing

If the comparison shows likely local-only, local-newer, or otherwise meaningful local database content:
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
- record the exact backup path for the final report

Block the database import if backup creation fails.

### Phase 4.5: Snapshot local-only tool overlay

Run this only when database refresh is active and local-only tool preservation is enabled.

This phase snapshots a narrow allowlist of local-only tool state before the live/staging database replaces LocalWP. It is not a general database merge.

For Novamira/Novamira Pro, detect local plugin files:
- `wp-content/plugins/novamira/novamira.php`
- `wp-content/plugins/novamira-pro/novamira-pro.php`

If those files exist locally, snapshot:
- activation state for `novamira/novamira.php` and `novamira-pro/novamira-pro.php` from the serialized `active_plugins` option
- exact `wp_options` rows for:
  - `novamira_ai_abilities_enabled`
  - `novamira_ai_abilities_domain`
  - `novamira_ability_rules`
  - `novamira_pro_upsell_installed_at`
  - `nvp_license_key`
  - `nvp_license_status`
  - `nvp_license_error`
  - `nvp_license_domain`
  - `nvp_memory_enabled`
  - `nvp_instructions_enabled`
  - `nvp_instructions_content`
- `wp_usermeta` rows with these keys:
  - `novamira_production_warning_dismissed`
  - keys beginning with `novamira_pro_dismissed_`
- Novamira memory content when present:
  - `wp_posts` rows with `post_type = 'novamira_memory'`
  - `wp_postmeta` rows attached to those posts, especially `_novamira_memory_type`
  - revisions whose `post_parent` points to a preserved `novamira_memory` post, only when they can be safely remapped

Do not preserve Novamira update/cache transients by default:
- `_transient_novamira%`
- `_transient_timeout_novamira%`
- `_transient_novamira-pro%`
- `_transient_timeout_novamira-pro%`

Do not print license keys, tokens, application passwords, or instruction content in the assistant output. Report only option names, row counts, and whether the snapshot exists.

If a local-only plugin has an unknown footprint, preserve only activation state and explicit user-provided allowlist rows. Otherwise block and ask for the missing allowlist.

### Phase 5: Export remote GridPane database

Run this only when database refresh is active.

- connect to the GridPane source over SSH
- run the remote export from the GridPane site root
- prefer WP-CLI export when available
- keep the export file in a temporary or backup-safe remote location
- do not run search-replace on the remote source
- request or preserve a dump that includes `SET NAMES utf8mb4`
- if WP-CLI refuses because the SSH session is root, rerun the export with `--allow-root` rather than changing server users blindly
- if the GridPane dump starts with a MariaDB sandbox compatibility line such as `/*M!999999\- enable the sandbox mode */` and LocalWP's older client rejects it, create a byte-preserving sanitized copy that removes only that first line

Example command shape:

```bash
cd /var/www/example.com/htdocs && wp db export /tmp/example-refresh-YYYYMMDD-HHMM.sql --allow-root
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
- pass `--default-character-set=utf8mb4` to the LocalWP MySQL client
- confirm the dump contains `SET NAMES utf8mb4`, or prepend an equivalent statement without rewriting the dump body
- prefer client file input for full imports; do not rely on `source` through `mysql -e` unless that exact client has been tested to support it
- do not use generic PHP, `wp-load.php`, or an unrelated MySQL client as the first path
- run a quick post-import query to confirm the database responds
- query the current session character set after import validation with `SET NAMES utf8mb4; SHOW VARIABLES LIKE 'character_set%';` when encoding-sensitive content exists
- after import, confirm local `wp-config.php` still points `DB_HOST` at the actual LocalWP DB endpoint
- if `DB_HOST` is `localhost` and the resolved LocalWP database uses a non-default TCP port, update the local-only `wp-config.php` value to `127.0.0.1:{MYSQL_PORT}` before browser validation
- treat this as LocalWP environment repair, not a deployable code change

### Phase 8: Run local URL search-replace

Run this when database refresh is active and source and local domains differ.

- replace source domain with LocalWP domain
- verify `siteurl` and `home` after the replacement

Use this fallback ladder:

1. Prefer local WP-CLI when available, using serialized-data-safe search-replace options.
2. If local `wp` is not on PATH, search for a project-local or user-local WP-CLI executable or `wp-cli.phar`.
3. If WP-CLI is unavailable but the LocalWP web PHP runtime can load WordPress, create a temporary token-protected helper in the LocalWP web root that bootstraps `wp-load.php`, runs `$wpdb->query('SET NAMES utf8mb4')`, handles serialized values safely, and reports changed cell counts.
4. Delete the helper immediately after it runs, whether it succeeds or fails.
5. If no serialized-safe path is available, block and report the missing tooling.

Do not use naive SQL `REPLACE()` against serialized data.

After search-replace, validate at least:
- `siteurl` and `home`
- obvious live-domain leftovers in `wp_options`
- obvious live-domain leftovers in primary `wp_posts` fields such as `post_content` and `guid`

Phrase this as a primary-table check, not proof that no plugin table contains any live URL. Some plugin tables may intentionally store external URLs or historical logs.

### Phase 8.5: Restore local-only tool overlay

Run this after the URL search-replace when database refresh is active and Phase 4.5 created a local-only tool snapshot.

For Novamira/Novamira Pro:
- restore only the allowlisted `wp_options` rows captured in Phase 4.5
- re-add `novamira/novamira.php` and `novamira-pro/novamira-pro.php` to `active_plugins` only when the corresponding plugin file still exists locally
- restore allowlisted `wp_usermeta` rows without printing values
- restore `novamira_memory` posts only when present in the snapshot
- when restoring `novamira_memory` posts, avoid overwriting live-imported `wp_posts` IDs; insert with new IDs and remap postmeta/revision parent IDs unless the original IDs are confirmed unused
- do not restore Novamira update/checker transients
- verify Novamira remains locked to the LocalWP domain when `novamira_ai_abilities_domain` is present

If restoration fails, keep the full LocalWP database backup and the local-only tool snapshot, then report the exact blocked item.

### Phase 8.6: Reconcile LocalWP plugin activation policy

Run this after local-only tool restoration and before uploads sync when database refresh is active.

The imported GridPane database may mark server-side infrastructure plugins as active. If those plugin files are missing locally, WordPress may show "plugin has been deactivated because the files do not exist." If those plugin files are installed locally for parity, they may run behavior that belongs only on GridPane.

Use a serialized-safe WordPress/API method to reconcile `active_plugins`; do not edit the serialized option with naive string operations.

For this project pattern, force these plugins inactive in LocalWP when present in `active_plugins`:
- `nginx-helper/nginx-helper.php` for the GridPane Nginx Helper fork
- `redis-cache/redis-cache.php` for the Rhubarb Group Redis Object Cache plugin

If the plugin files exist locally:
- remove them from `active_plugins`
- keep the files installed
- report them as "installed locally, forced inactive"

If the plugin files do not exist locally:
- remove them from `active_plugins`
- report them as "missing locally, deactivated to prevent plugins.php warnings"
- do not copy plugin files from GridPane during this workflow

For Redis Object Cache:
- do not enable or install the `wp-content/object-cache.php` drop-in on LocalWP unless the user explicitly says LocalWP Redis/object-cache testing is intended
- if the drop-in exists locally and Redis should be inactive, report it as a validation warning rather than deleting it automatically

Do not deactivate normal shared functional plugins through this policy. Only apply this to explicit environment-plugin allowlist entries.

### Phase 8.7: Reconnect LocalWP-only MCP clients

Run this after local-only tool restoration and plugin activation reconciliation when a LocalWP-only MCP/client tool was preserved or expected, especially Novamira/Novamira Pro.

Why this is needed:
- a production/staging database import can replace LocalWP `wp_usermeta` application password rows
- preserving Novamira plugin activation and options is not enough to preserve the current AI client's WordPress application password
- the symptom is usually that Novamira MCP tools still exist in the AI client, but calls return `401`, `rest_forbidden`, or a similar authentication error

For Novamira:
- after restoring the local-only overlay, test whether the configured Novamira MCP server can still list or discover tools
- if it works, report that no reconnect was needed
- if it returns `401`, `rest_forbidden`, or an application-password failure, prefer an on-demand LocalWP-only temporary reconnect helper before asking the user to log in manually
- create the helper only when the LocalWP target has already been confirmed and the current task approval includes MCP/client reconnect; otherwise ask for explicit approval before creating it
- create the helper in the confirmed LocalWP web root or another confirmed LocalWP-only operator path, never in the child theme, plugin repository, uploads folder, workflow repo, GridPane path, or any deployable code surface
- give the helper a random filename and require a separate random one-time token in the request
- make the helper refuse to run unless the WordPress `home` and `siteurl` resolve to the expected LocalWP domain and the loaded `ABSPATH` resolves inside the expected LocalWP web root
- make the helper bootstrap the confirmed LocalWP WordPress install through `wp-load.php`, then use WordPress APIs rather than direct database writes where practical
- prefer creating a new WordPress application password for an existing trusted admin user from the site profile, known local MCP config username, or explicit user instruction, using `WP_Application_Passwords::create_new_application_password()` or the equivalent supported API
- do not create a new administrator account unless no suitable admin user exists and the user explicitly approves that fallback in the current task
- when a temporary admin fallback is approved, create a random username/password, use it only to create or recover the local MCP credential, then delete or demote the temporary account before the helper exits
- print the generated application password only to the local process that immediately updates the AI client config; do not send it to chat, persistent logs, workflow notes, shell history, or saved inspection files
- make the helper delete itself before exit, including failure paths when technically possible, then verify from the filesystem that the helper file no longer exists
- if the helper path is unsafe, cannot bootstrap WordPress, cannot identify an admin user, cannot self-delete, or cannot be verified removed, stop the helper path and fall back to browser-based `wp-admin`
- browser fallback: open the LocalWP `wp-admin` Novamira Configuration page when browser automation is available
- if the browser fallback is not already logged in, ask the user to log in manually, then continue
- in browser fallback, generate a new WordPress application password from the Novamira Configuration page
- update only the matching local AI client MCP config server block, when the config path is known and writable
- create a timestamped backup of the AI client config before editing it
- pass credentials only as environment variables such as `WP_API_URL`, `WP_API_USERNAME`, and `WP_API_PASSWORD`
- keep the Novamira transport args exactly as the generated setup prompt specifies, usually `["-y", "@automattic/mcp-wordpress-remote@latest"]`
- do not pass credentials as CLI flags
- do not print the generated application password in chat or logs
- delete any temporary page-inspection files, generated verifier scripts, local snippets, or config fragments that contain the password after verification
- verify in a fresh MCP process or fresh client session when possible by listing the Novamira adapter tools
- if the current chat cannot reload MCP servers, report that the refreshed server should be available in a fresh chat or after restarting/reloading the AI client

If the AI client config cannot be located or modified:
- tell the user to copy the Novamira-generated setup prompt or JSON snippet manually
- report that WordPress was refreshed successfully but the local MCP client still needs manual reconnect

When the local AI Workflows task library is available, use the Novamira MCP server config workflow as the client-config reference:
- `C:\Users\Captain\Documents\AI Workflows\Task Workflows\WordPress\novamira-mcp-server-config-workflow.md`

### Phase 9: Sync missing uploads

Run this when uploads refresh is active.

- source path: remote `wp-content/uploads/`
- target path: LocalWP `wp-content/uploads/`
- default behavior: copy only missing files
- never pass a delete flag
- do not sync `themes/`, `plugins/`, WordPress core, workflow files, or project notes
- if overwrite was explicitly approved, overwrite uploads only and report that approval

Before copying, run a missing-only preview that reports:
- total remote upload files
- total missing local files
- representative missing paths
- rough categories, such as media library files, generated thumbnails, private uploads, plugin-generated assets, logs, temp files, email attachments, and PDF/form outputs

For Windows-to-GridPane work, prefer a clear file transfer method that can preserve nested upload paths and produce a count or dry-run summary before treating the sync as complete.

When copying:
- create local directories as needed
- re-check local existence immediately before each copy
- copy only missing files by default
- report copied, skipped-existing, and failed counts
- run a final missing-file comparison after sync

### Phase 10: Validate LocalWP state

At minimum, validate:
- LocalWP database connection
- `siteurl` and `home`
- representative post/page counts
- active theme name
- active plugin list or obvious plugin mismatch warnings
- local-only preserved plugins are still active when requested, especially `novamira/novamira.php` and `novamira-pro/novamira-pro.php`
- GridPane-only infrastructure plugins are inactive in LocalWP, especially `nginx-helper/nginx-helper.php` and `redis-cache/redis-cache.php`
- no missing-plugin warnings remain for deactivated environment plugin entries when practical to verify
- Novamira/Novamira Pro preserved options are present without exposing their values
- Novamira MCP/client connectivity is verified or clearly reported as requiring manual reconnect after the database import
- if a temporary reconnect helper was used, the helper file is verified deleted and any temporary admin fallback account is verified deleted or demoted
- `wp-config.php` `DB_HOST` includes the LocalWP host and port when needed for plugin-owned PDO/database layers
- representative pages listed in context
- a representative media URL or file path
- representative emoji or four-byte UTF-8 content when the source site contains comments, reviews, user content, or other fields that may include emoji
- absence of obvious source-domain leftovers in primary WordPress tables when practical
- HTTP status for `/`
- HTTP status for at least one key route such as `/library/` when the project has one
- browser-level check when Playwright or another approved browser tool is available
- console-error summary that separates third-party telemetry/ad/video errors from app or page failures

Plugin or theme parity issues are warnings or blockers for local testing. Do not fix them by syncing code through this workflow.

Validation should be honest about scope. Do not claim every live URL is gone unless a full database-wide serialized-safe scan was actually performed.

### Phase 11: Clean up temporary files

After successful import, search-replace, and uploads sync:
- keep the local pre-refresh DB backup
- delete the remote source SQL dump from `/tmp/` or the chosen temporary remote location
- delete the local copied source SQL dump unless the user explicitly asks to keep it
- delete any temporary search-replace helper immediately after it runs
- delete any temporary MCP/client reconnect helper immediately after it runs, verify it is absent from the LocalWP filesystem, and delete any secret-bearing reconnect verifier or inspection files
- report what was kept and what was removed

Do not delete the local pre-refresh backup automatically.

### Phase 12: Report result

Report completed, skipped, blocked, and manually verified steps using the output format below.

---

## Common Pitfalls

- importing into the wrong LocalWP site because two local site names are similar
- assuming one fixed LocalWP `sites.json` shape and missing MariaDB service ports
- leaving LocalWP `DB_HOST` as `localhost` when a plugin-owned PDO connection needs `127.0.0.1:{MYSQL_PORT}`
- ignoring local/source comparison findings and accidentally replacing local-only content
- assuming the local/source comparison can detect every local-only edit
- skipping the local database backup because LocalWP feels disposable
- trying to merge selected local database rows into the pulled-down GridPane database
- losing LocalWP-only tool configuration by replacing the database without a local-only preservation overlay
- assuming restored Novamira plugin options also preserve the AI client's WordPress application password; the imported database can invalidate the LocalWP MCP credential and require reconnect
- leaving a reconnect or temporary-admin helper permanently in the LocalWP web root, child theme, plugin repository, uploads folder, or any path that could be deployed
- running a credential helper without hard-checking that it loaded the expected LocalWP domain and web root
- creating a temporary admin account when a new application password for an existing trusted admin would have been enough
- restoring local-only CPT rows by fixed IDs and accidentally overwriting imported live content
- leaving GridPane-only cache/server plugins active in LocalWP after importing the live database
- confusing "installed locally for parity" with "active locally"; infrastructure plugins may need files present but activation forced off
- forgetting `--allow-root` when GridPane WP-CLI is run from a root SSH session
- importing with a `latin1` client/session even though WordPress tables are `utf8mb4`; this can turn emoji into literal `?` bytes
- removing a MariaDB dump compatibility line by rewriting the whole SQL dump as text, which can damage binary or escaped payloads
- assuming `mysql -e "source file.sql"` works in every LocalWP MySQL/MariaDB client
- using this workflow to pull production code instead of using Git
- using destructive upload sync flags that delete local files
- overwriting local media when missing-only sync was enough
- corrupting serialized data with naive SQL search-replace
- leaving remote SQL dumps or temporary local helper scripts behind
- leaving generated application passwords in chat logs, inspection files, verifier scripts, shell history, or workflow notes after reconnecting MCP clients
- treating third-party telemetry or video/ad console failures as proof that the local refresh failed
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
Source/local DB comparison: [done / blocked for approval / skipped with reason]
Database backup: [created / blocked / skipped with reason]
Database import: [done / blocked / not requested]
Search-replace: [done / blocked / not needed]
Local-only tool preservation: [restored / blocked / skipped with reason]
Plugin activation policy: [reconciled / blocked / skipped with reason]
MCP/client reconnect: [verified / reconnected / manual action needed / skipped with reason]
Uploads sync: [missing-only / overwrite-approved / blocked / not requested]
Cleanup: [done / blocked / not needed]
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
- whether source/local database comparison found likely local-only or local-newer changes
- where the local database backup was created when applicable
- whether the import and search-replace ran through an explicit `utf8mb4` database session
- the search-replace method used and whether serialized values were handled safely
- whether local-only tool/plugin configuration was preserved and restored
- which environment plugins were forced inactive locally
- whether Novamira MCP/client connectivity was verified, reconnected, or left for manual action after the database import
- whether any temporary reconnect helper self-deleted and was verified absent, and whether any temporary admin fallback account was removed or demoted
- whether uploads were missing-only or overwrite-approved
- whether temporary source dumps and helper files were cleaned up
- which validations passed
- any blockers or manual checks still needed

Proceed with the LocalWP reverse refresh workflow now.

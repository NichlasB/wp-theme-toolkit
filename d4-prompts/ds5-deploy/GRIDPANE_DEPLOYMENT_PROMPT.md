<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# GridPane Deployment Workflow

Use this prompt when a Meta Views Stack site is ready to move from LocalWP to a GridPane production server.

This workflow documents the repeatable handoff from local code and database state to a live production domain.

It is a deployment workflow, not a site-bootstrap workflow.

---

## Purpose

Run this after build work, reviews, and the 01-06 pre-launch sequence are complete.

Use it to:
- confirm the local site is ready to ship
- deploy the child theme through Git or a clean deployment copy when needed
- migrate database content and uploads safely
- verify production behavior before DNS cutover and after go-live
- record the deployment in `DEPLOYMENT_CHECKLIST.md`

Default stance:
- treat the GridPane target as production-ready from the first deployment onward
- prefer a production-ready child-theme payload over mirroring the full LocalWP working tree

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
- production domain
- GridPane server IP or hostname
- GridPane SSH user and site path
- Git repository URL for the child theme
- preferred migration method: All-in-One WP Migration, WP Migrate, or Duplicator

Helpful optional inputs:
- whether DNS is already pointed at GridPane
- whether production already has the paid plugin zip files available
- whether a reverse migration back to local is expected immediately after launch
- whether the child-theme deploy surface has already been cleaned of non-runtime files the user does not want on the server
- whether a child-theme `.distignore` file exists and should define the clean deployment payload
- a project-specific DB export override, only when the default LocalWP to GridPane export method does not apply

---

## Required Outputs

During this workflow, create or update:

1. the matching row in `DEPLOYMENT_CHECKLIST.md`
2. a concise deployment log entry in chat
3. a short list of blockers or manual follow-up items when needed

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

## Deployment Phases

### Phase 0: Load or bootstrap site context

- resolve the target child-theme path first
- check for `[child-theme-root]/gridpane-deploy-context.md`
- read it before proposing commands when it exists
- if it is missing or incomplete, collect only the missing site-specific fields, show the filled sample template, then create or update the file before continuing
- treat the LocalWP to GridPane DB export method as a shared default unless the context file explicitly overrides it

### Phase 1: Prepare the local site

- confirm all child-theme code is committed and pushed to GitHub
- confirm the child-theme deploy surface is production-ready and does not include tracked non-runtime files the user does not want on GridPane
- if a child-theme `.distignore` file exists, use it as the baseline exclusion rule for any clean deployment copy
- run final functional QA in LocalWP
- export the local database with a migration plugin
- confirm the uploads library is included in the migration package when needed

Do not continue if the child-theme repo has unreviewed local changes.

Do not continue if the child-theme deploy surface still includes local-only planning notes, temporary workflow files, migration runbooks, or maintenance utilities the user does not want on the server.

### Phase 2: Set up the GridPane server

- provision the server if needed
- create the site in GridPane
- confirm the fresh WordPress installation loads correctly
- note the SSH credentials and the production site path

Typical SSH start:

```bash
ssh gridpane-user@server-ip
cd /var/www/example.com/htdocs
```

### Phase 3: Install plugins and theme

- install the free Blocksy parent theme from the WordPress theme repository
- upload and activate Blocksy Pro, Meta Box AIO, and project-specific plugins
- do not activate the child theme yet

The child theme should be activated only after the Git clone step completes.

### Phase 4: Deploy the child theme

Choose one path:

- Git path: SSH into the server, navigate to `wp-content/themes/`, clone the child-theme repo into `blocksy-child/`, handle authentication through a PAT or SSH key, then activate the child theme in WordPress admin after the clone completes
- clean archive path: package only the approved runtime deploy surface, using `.distignore` as the baseline exclusion list when present, upload the archive, extract it into `blocksy-child/`, then normalize ownership and permissions before activation

The deployed theme should represent the production-ready deploy surface, not the full LocalWP working tree.

Example:

```bash
ssh gridpane-user@server-ip
cd /var/www/example.com/htdocs/wp-content/themes
git clone git@github.com:owner/blocksy-child.git blocksy-child
```

If the server uses HTTPS authentication instead of SSH keys, use a PAT-backed clone URL.

See `d3-guides/GIT_WORKFLOW_GUIDE.md` for the post-launch `git pull` rhythm.

### Phase 5: Migrate the database and uploads

Document and choose one of these options:
- All-in-One WP Migration - easiest path
- WP Migrate - cleanest path for pro workflows
- Duplicator - more manual, but reliable when needed

After migration, run WP-CLI search-replace if local URLs remain:

```bash
cd /var/www/example.com/htdocs
wp search-replace 'yoursite.local' 'yoursite.com' --precise --recurse-objects
```

### Phase 6: Verify and fix URLs

- test key pages, menus, images, and MB Views rendering
- test forms and dynamic functionality
- confirm links, CTA targets, and navigation paths
- run search-replace again if URLs remain inconsistent

### Phase 7: Go live

- point the DNS A record at the GridPane server IP
- wait for DNS resolution and Let's Encrypt SSL issuance
- confirm the site URL in WordPress Settings -> General
- test the real domain after SSL is active

Expect a 15 to 60 minute delay for SSL issuance after DNS resolves.

### Phase 8: Post-launch workflow

Document the two-channel ongoing rhythm:
- code updates: edit locally -> commit -> push -> SSH -> `git pull`
- content updates: edit directly on production through WordPress admin

Example update pull:

```bash
ssh gridpane-user@server-ip
cd /var/www/example.com/htdocs/wp-content/themes/blocksy-child
git pull origin main
```

When local needs the latest production content, perform a reverse migration from production back to LocalWP.

---

## Common Pitfalls

- SSL certificate delay after DNS changes - wait for DNS to resolve before treating certificate issuance as broken
- pushing docs, temp notes, migration runbooks, or maintenance-only helper files to GridPane just because they were present locally
- assuming the first launch must be a raw Git clone even when `.distignore` or other tracked non-runtime files make a clean deployment copy safer
- file permission issues on GridPane - use the GridPane permissions fix command when ownership looks wrong

```bash
gp fix perms example.com
```

- cached assets not updating after `git pull` - flush any GridPane, plugin, CDN, or browser caches
- MB Views not showing after migration - confirm the migration tool included the relevant post types and settings data
- serialized data corruption from naive search-replace - always use `--precise --recurse-objects`

---

## Output Format

Report the deployment result in this structure:

```text
Target project: [name]
Theme root: [path]
Production domain: [domain]
GridPane path: [path]
Git repository: [url]
Migration method: [tool]
Checklist updated: [yes / no]
Phase status:
- Phase 1: [done / blocked]
- Phase 2: [done / blocked]
- Phase 3: [done / blocked]
- Phase 4: [done / blocked]
- Phase 5: [done / blocked]
- Phase 6: [done / blocked]
- Phase 7: [done / blocked]
- Phase 8: [done / blocked]
Open issues:
- [issue or none]
Next action: [short recommendation]
```

Keep the output concise and operational.

---

## Final Assistant Output

After the deployment work is complete, report:
- the exact target project and theme root used
- the migration method used
- the production domain and GridPane path
- whether `DEPLOYMENT_CHECKLIST.md` was updated
- which phases completed and which phases are still blocked
- the most relevant next action

Proceed with deployment now.
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
- deploy the child theme through Git
- migrate database content and uploads safely
- verify production behavior before DNS cutover and after go-live
- record the deployment in `DEPLOYMENT_CHECKLIST.md`

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `d1-setup/STACK_REFERENCE.md`
- `d3-guides/GIT_WORKFLOW_GUIDE.md`
- `DEPLOYMENT_CHECKLIST.md`

Treat `GIT_WORKFLOW_GUIDE.md` as the source of truth for the code-versus-content split.

---

## Required Inputs

If the user has not already provided them, gather these inputs first:
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

---

## Required Outputs

During this workflow, create or update:

1. the matching row in `DEPLOYMENT_CHECKLIST.md`
2. a concise deployment log entry in chat
3. a short list of blockers or manual follow-up items when needed

---

## Deployment Phases

### Phase 1: Prepare the local site

- confirm all child-theme code is committed and pushed to GitHub
- run final functional QA in LocalWP
- export the local database with a migration plugin
- confirm the uploads library is included in the migration package when needed

Do not continue if the child-theme repo has unreviewed local changes.

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

### Phase 4: Deploy the child theme via Git

- SSH into the server
- navigate to `wp-content/themes/`
- clone the child-theme repo into `blocksy-child/`
- handle authentication through a PAT or SSH key
- activate the child theme in WordPress admin after the clone completes

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
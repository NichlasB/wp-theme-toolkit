# Git Workflow Guide

This guide documents when Git enters the project lifecycle, what it tracks, what it does not track, how deployment differs from repository scope, and how code stays separate from database-backed content.

## Purpose

Treat Git as the source of truth for the approved child-theme repository surface, not for WordPress content or settings stored in the database.

Git scope and deployment scope are related, but they are not identical:

- Git can track runtime code plus selected project knowledge files
- the GridPane deployment payload should contain runtime assets by default
- local-only operator files should stay out of both Git and deployment unless there is a deliberate reason to keep them

## When Git Enters The Project

Git enters after the child-theme scaffold exists and before any real code is written.

1. Create the site in LocalWP - no Git yet
2. Install Blocksy, Blocksy Pro, and Meta Box AIO - no Git yet
3. Create the `blocksy-child/` scaffold with `style.css`, `functions.php`, `inc/`, `mb-json/`, `views/`, `.gitignore`, and any approved project files such as `_project-context.md` - Git enters here
4. Open `blocksy-child/` in the IDE
5. Run `git init` and create the first commit with the scaffold
6. Create a private GitHub repository
7. Connect the remote and push

All real code generation and refinement should happen after this point so every iteration is captured.

## What Git Tracks

Git should track the approved repository surface, not automatically every file that happens to exist inside `blocksy-child/`.

### Usually track and deploy

- `style.css`
- `functions.php`
- `inc/`
- `assets/`
- tracked `.mbjson` files under `mb-json/`
- `views/` local reference copies
- page template PHP files
- `screenshot.jpg`

### May track in Git, but do not deploy by default

- `_project-context.md`
- approved planning notes, migration references, or operator documentation the team wants preserved in GitHub
- repository metadata such as `.gitignore`

These files can be useful in the repository without belonging on GridPane.

### Keep local only unless there is a deliberate exception

- `session-context.tmp.md`
- `session-handoff.tmp.md`
- other `*.tmp.md` workflow files
- ad hoc maintenance helpers that are only for one-time local or operator use

If a file is not runtime-relevant and is not valuable as shared project knowledge, do not track it.

## What Git Does Not Track

- the Blocksy parent theme and other third-party themes
- third-party plugins
- WordPress core
- the uploads folder
- the WordPress database, including posts, pages, MB Views stored in the database, and Blocksy Customizer settings

Do not use Git as a dumping ground for temporary migration packages, SQL exports, or local-only operator artifacts.

## The Two-Channel Rule

The Meta Views Stack uses two separate channels.

| Channel | What It Carries | How It Moves |
|---------|-----------------|--------------|
| Code and shared project knowledge | `.mbjson`, `.php`, Twig files, CSS, selected project docs such as `_project-context.md` | Git -> GitHub -> `git pull` on production for runtime assets; non-runtime tracked docs stay in the repo but are excluded from clean deployment payloads |
| Content and settings | posts, pages, field values, MB Views templates, Blocksy settings, uploads | database migration plugin such as WP Migrate, All-in-One WP Migration, or Duplicator |

Code lives in version control. Content lives in the database. They meet at deploy time.

Deployment should use the runtime subset of the repository, not blindly mirror the entire working tree to GridPane.

## Daily Commit Rhythm

Commit after each meaningful chunk of work, such as a finished section, a completed view, or a CSS refinement pass.

```bash
git add .
git commit -m "Add features section to homepage view"
git push
```

## Post-Launch Update Rhythm

Once the site is live on GridPane:

- code updates: edit locally -> commit -> push -> SSH into GridPane -> `git pull`
- content updates: edit directly on production through WordPress admin

When LocalWP needs the latest production or staging content, run `@LOCALWP_REVERSE_REFRESH_PROMPT.md`. That workflow pulls database content and missing uploads back to LocalWP while keeping code movement in Git.

If the repository contains tracked non-runtime files that the user does not want on the server, do not treat `git pull` as the only acceptable deployment path. Use a clean deployment copy when needed so the GridPane payload stays production-ready. Development-only guardrails such as `AGENTS.md`, `AI_CODING_RULES.md`, `docs/ENGINEERING_STANDARD.md`, `opencode.json`, and `.opencode/` stay tracked in Git but are excluded from clean runtime payloads by default.

Never edit code directly on production.

Never commit content to Git.

## `.gitignore` Recommendations

Use a child-theme `.gitignore` that keeps local-only workflow clutter out of the repository.

```text
# OS
.DS_Store
Thumbs.db

# Editor
.cursor/
.vscode/
.idea/

# Meta Box export copies
mb-json/*.json

# Session context files
session-context.tmp.md
session-handoff.tmp.md
*.tmp.md
```

Track `.mbjson` files as the canonical Meta Box schema source and ignore duplicate `.json` export copies to prevent drift.

If the team decides certain tracked project docs should live in GitHub but never ship to GridPane, handle that in the deployment workflow or deployment packaging rules, not in `.gitignore`.

Important: Meta Box Builder local-file mode scans `*.json` by default. If the project intentionally keeps only tracked `.mbjson` files, add this bridge to `functions.php` so field groups still load in wp-admin:

```php
add_filter( 'mbb_json_files', static function ( $files ) {
	$mbjson_files = glob( get_stylesheet_directory() . '/mb-json/*.mbjson' );

	if ( false === $mbjson_files || empty( $mbjson_files ) ) {
		return $files;
	}

	return array_values( array_unique( array_merge( $files, $mbjson_files ) ) );
} );
```

Without that bridge, Meta Box can show `File not found` or `No JSON available` and may stop loading the field groups from the editor even though the tracked `.mbjson` files exist in Git.

Keep `.gitkeep` in empty folders such as `mb-json/` and `views/` so a fresh scaffold clones correctly.

## Cross-Reference

- `d1-setup/STACK_REFERENCE.md` defines the scaffold Git should track
- `d1-setup/LOCALWP_BLUEPRINT_SETUP.md` defines the reusable LocalWP starter before Git begins
- `d4-prompts/ds5-deploy/GRIDPANE_DEPLOYMENT_PROMPT.md` uses this guide for the production update rhythm and Git deploy step
- `d4-prompts/ds5-deploy/LOCALWP_REVERSE_REFRESH_PROMPT.md` uses this guide to keep reverse content refreshes separate from code sync
- `d4-prompts/ds6-git/GIT_OPERATIONS_PROMPT.md` uses this guide when the target is a child-theme or site repo

# Git Workflow Guide

This guide documents when Git enters the project lifecycle, what it tracks, what it does not track, and how code stays separate from database-backed content.

## Purpose

Treat Git as the source of truth for the child theme code surface, not for WordPress content or settings stored in the database.

## When Git Enters The Project

Git enters after the child-theme scaffold exists and before any real code is written.

1. Create the site in LocalWP - no Git yet
2. Install Blocksy, Blocksy Pro, and Meta Box AIO - no Git yet
3. Create the `blocksy-child/` scaffold with `style.css`, `functions.php`, `inc/`, `mb-json/`, `views/`, `_project-context.md`, and `.gitignore` - Git enters here
4. Open `blocksy-child/` in the IDE
5. Run `git init` and create the first commit with the scaffold
6. Create a private GitHub repository
7. Connect the remote and push

All real code generation and refinement should happen after this point so every iteration is captured.

## What Git Tracks

- the entire `blocksy-child/` folder
- `style.css`
- `functions.php`
- `inc/`
- tracked `.mbjson` files under `mb-json/`
- `views/` local reference copies
- `_project-context.md`
- `.gitignore`

## What Git Does Not Track

- the Blocksy parent theme and other third-party themes
- third-party plugins
- WordPress core
- the uploads folder
- the WordPress database, including posts, pages, MB Views stored in the database, and Blocksy Customizer settings

## The Two-Channel Rule

The Meta Views Stack uses two separate channels.

| Channel | What It Carries | How It Moves |
|---------|-----------------|--------------|
| Code | `.mbjson`, `.php`, Twig files, CSS, `_project-context.md` | Git -> GitHub -> `git pull` on production |
| Content and settings | posts, pages, field values, MB Views templates, Blocksy settings, uploads | database migration plugin such as WP Migrate, All-in-One WP Migration, or Duplicator |

Code lives in version control. Content lives in the database. They meet at deploy time.

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

Never edit code directly on production.

Never commit content to Git.

## `.gitignore` Recommendations

Use a standard child-theme `.gitignore`.

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
```

Track `.mbjson` files as the canonical Meta Box schema source and ignore duplicate `.json` export copies to prevent drift.

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
- `d4-prompts/ds6-git/GIT_OPERATIONS_PROMPT.md` uses this guide when the target is a child-theme or site repo
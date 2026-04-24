# Meta Views Stack Reference

This is the single source of truth for the site-building stack supported by `wp-theme-toolkit`.

## Stack Definition

The Meta Views Stack is a code-first WordPress site workflow built around these tools:

- LocalWP for local WordPress development
- Blocksy Pro as the parent theme
- a Blocksy child theme as the code surface
- Meta Box AIO for CPTs, fields, groups, repeaters, and MB Views
- MB Views for Twig, HTML, and CSS rendering
- Git for version control
- VS Code, Copilot, Codex, Cursor, or Windsurf for generation and review
- Element to LLM for live DOM and style capture during refinement

The defining rule: do not rely on a visual page builder as the primary template system. Keep the data model, design tokens, view markup, and CSS legible in plain-text files.

## Canonical Child Theme Structure

```text
blocksy-child/
├── .gitignore
├── style.css
├── functions.php
├── _project-context.md
├── inc/
│   └── cpt.php
├── mb-json/
│   ├── .gitkeep
│   └── [name].mbjson
└── views/
    ├── .gitkeep
    ├── single/
    ├── archive/
    ├── sections/
    └── reference/
```

Rules:
- `style.css` contains the child-theme header and the canonical token block
- `functions.php` loads the parent stylesheet, conditionally loads child includes, and exposes tracked `.mbjson` field-group files to Meta Box Builder through `mbb_json_files` when the project does not keep duplicate `.json` twins
- `_project-context.md` is the operational context file for AI and humans
- `inc/cpt.php` stores CPT registration snippets
- `mb-json/` stores reusable field schemas as tracked `.mbjson` files and should contain a `.gitkeep` file until real files exist
- `views/` stores local reference copies of all Twig and CSS pasted into MB Views and should contain a `.gitkeep` file until real files exist
- `.gitignore` excludes editor folders and temporary session files from the child-theme repository

## Required Project Artifacts

Every project should maintain these artifacts:

1. `_project-context.md`
2. a placement map inside `_project-context.md`
3. `mb-json/*.mbjson` files for field groups and repeaters
4. local reference copies of view Twig and CSS under `views/`
5. `inc/cpt.php` for CPT registration when CPTs are used

For faster new project setup, build from the reusable LocalWP blueprint in `LOCALWP_BLUEPRINT_SETUP.md`.

Git should enter the project only after the child-theme scaffold exists. See `d3-guides/GIT_WORKFLOW_GUIDE.md` for the exact timing.

## Minimum Child Theme Boilerplate

### style.css

```css
/*
Theme Name: Blocksy Child
Template: blocksy
Version: 1.0.0
Text Domain: blocksy-child
*/

:root {
  --content-max-width: 72rem;
  --content-narrow-width: 48rem;
  --space-xs: 0.25rem;
  --space-sm: 0.5rem;
  --space-md: 1rem;
  --space-lg: 2rem;
  --space-xl: 4rem;
  --space-2xl: 6rem;
  --text-sm: 0.875rem;
  --text-base: 1rem;
  --text-lg: 1.125rem;
  --text-xl: 1.25rem;
  --text-2xl: 1.5rem;
  --text-3xl: 2rem;
  --text-4xl: clamp(2rem, 5vw, 3.2rem);
}
```

### functions.php

```php
<?php
/**
 * Child theme bootstrap.
 */

function mv_get_child_asset_version( $relative_path, $fallback_version ) {
    $relative_path = ltrim( (string) $relative_path, '/\\' );
    $asset_path    = get_stylesheet_directory() . '/' . $relative_path;

    if ( file_exists( $asset_path ) ) {
        $modified_time = filemtime( $asset_path );

        if ( false !== $modified_time ) {
            return (string) $modified_time;
        }
    }

    return (string) $fallback_version;
}

add_action( 'wp_enqueue_scripts', function () {
    $theme_version = wp_get_theme()->get( 'Version' );

    wp_enqueue_style(
        'blocksy-parent-style',
        get_template_directory_uri() . '/style.css',
        array(),
        wp_get_theme( get_template() )->get( 'Version' )
    );

    wp_enqueue_style(
        'blocksy-child-style',
        get_stylesheet_uri(),
        array( 'blocksy-parent-style' ),
        mv_get_child_asset_version( 'style.css', $theme_version )
    );
} );

add_filter( 'mbb_json_files', static function ( $files ) {
    $mbjson_files = glob( get_stylesheet_directory() . '/mb-json/*.mbjson' );

    if ( false === $mbjson_files || empty( $mbjson_files ) ) {
        return $files;
    }

    return array_values( array_unique( array_merge( $files, $mbjson_files ) ) );
} );

$cpt_file = get_stylesheet_directory() . '/inc/cpt.php';

if ( file_exists( $cpt_file ) ) {
    require_once $cpt_file;
}
```

Use the same helper for every child-theme CSS or JS asset added later.

Reason:
- a static `Version: 1.0.0` header is not enough during active refinement
- browsers can keep serving stale child-theme CSS or JS even when the file changed
- filemtime-based versions make local iteration and review much more reliable

Keep the `inc/cpt.php` include conditional. A fresh blueprint or early project scaffold may not have real CPT registrations yet.

Keep `functions.php` lean as the project grows.

- Leave asset versioning, core theme hooks, and a small `require_once` loader in `functions.php`
- Move page-, feature-, and domain-specific helpers into focused files under `inc/`
- Load PHP helper files with `require_once`; only CSS and JS assets are enqueued
- If a helper supports one feature area, add it to that feature's include file instead of appending more functions to `functions.php`

### inc/cpt.php

```php
<?php
/**
 * CPT registrations for the child theme.
 */
```

## Workflow Loop

For new projects, use `LOCALWP_BLUEPRINT_SETUP.md` to standardize the LocalWP starter site and `d3-guides/GIT_WORKFLOW_GUIDE.md` to introduce Git at the right point.

Use this sequence for all new work:

1. Plan the page or data model in `_project-context.md`
2. Generate or update `.mbjson` and `inc/cpt.php` artifacts from the plan, and keep the `mbb_json_files` bridge in `functions.php` when `.json` twins are intentionally not tracked
3. Generate Twig markup for the MB View
4. Generate CSS that only consumes the documented token system
5. Paste the Twig and CSS into MB Views
6. Record the live view name, slug, and placement rule in the placement map
7. Capture the live result with Element to LLM
8. Refine Twig and CSS against the real rendered output
9. Update the local reference copy under `views/`

During steps 3 and 8, confirm the MB Views data-access pattern is correct:
- use `post.*` for main-query field output
- use `mb.rwmb_meta()` for explicit page or post lookups
- do not write normal custom fields as `mb.field_id`

## Placement Map Rule

MB View assignments and Blocksy Content Block conditions often live in the database. That makes them easy to lose.

For every live assignment, add an entry to the placement map in `_project-context.md` with:
- artifact name
- source file or reference path
- live view name or content block name
- assigned location
- conditions
- notes about dependencies or sequence

If a Blocksy Content Block is only a placement layer for a file-backed MB View, record both sides of the relationship.

Example note:
- Content Block name: `Global Footer`
- source file: `views/sections/site-footer.twig`
- render bridge: Shortcode block with `[mbv name="sections/site-footer.twig"]`

If the project registers `mbv_fs_paths`, that shortcode can render the child-theme Twig file directly without creating a second MB View post just to hold the same template.

## What Not To Do

- Do not use the Meta Box Builder UI as the primary source of truth for fields
- Do not track duplicate Meta Box `.json` export twins alongside canonical `.mbjson` files, but do not omit the `mbb_json_files` bridge in `functions.php` when the project keeps `.mbjson` only
- Do not keep the only copy of Twig or CSS inside the WordPress admin
- Do not introduce a second spacing system or ad hoc breakpoint set
- Do not use raw hex values in view CSS
- Do not output normal custom fields as `mb.field_id`; use `post.*` or `mb.rwmb_meta()`
- Do not blur the boundary between MB Views and Blocksy Content Blocks
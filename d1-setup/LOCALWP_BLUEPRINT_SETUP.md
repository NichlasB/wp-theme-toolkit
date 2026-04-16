# LocalWP Blueprint Setup

Use this specification to create a reusable LocalWP blueprint for the Meta Views Stack.

The blueprint is created once, saved in LocalWP, and reused as the starting point for new site projects.

## Purpose

Standardize the LocalWP starting state so each project begins with the same plugins, theme baseline, child-theme scaffold, and WordPress settings.

This removes repetitive setup work and makes `PROJECT_BOOTSTRAP_PROMPT.md` start from a known structure.

## Required Plugins

- Meta Box AIO - core field, relationship, and MB Views surface
- Blocksy Companion Pro - unlocks Blocksy Pro features including Content Blocks

## Strongly Recommended Plugins

- Fluent Forms - common starting point for contact and lead forms
- WP Migrate or All-in-One WP Migration - database migration for GridPane deployment
- Query Monitor - debugging queries, hooks, template loading, and errors

## Optional But Useful Plugins

- WP Mail SMTP - test mail sends from LocalWP
- Regenerate Thumbnails - rebuild image sizes after changes
- User Switching - test flows from different user roles

## Theme Setup

- Install and activate the Blocksy parent theme
- Upload and activate Blocksy Pro
- Pre-create the `blocksy-child/` theme scaffold described below
- Leave the child theme inactive in the blueprint so each new project activates it intentionally

`functions.php` in the scaffold must load `inc/cpt.php` conditionally so a fresh blueprint does not break before any CPT code exists.

If the scaffold keeps Meta Box schemas as tracked `.mbjson` files without duplicate `.json` copies, `functions.php` must also expose those `.mbjson` files to Meta Box Builder through `mbb_json_files`; otherwise Meta Box local-file mode looks only for `*.json` and field groups can disappear from the editor.

## Child Theme Scaffold Structure

```text
blocksy-child/
├── .gitignore
├── style.css
├── functions.php
├── inc/
│   └── cpt.php
├── mb-json/
│   └── .gitkeep
├── views/
│   └── .gitkeep
└── _project-context.md
```

Notes:
- `mb-json/` and `views/` need `.gitkeep` so Git tracks the empty folders in a fresh scaffold
- `inc/cpt.php` can remain a placeholder file with only the opening PHP tag and docblock until real CPT registrations exist
- if the project tracks `.mbjson` only, add the `mbb_json_files` bridge to `functions.php` from the start instead of waiting for the first field-group sync issue
- keep the scaffold aligned with `STACK_REFERENCE.md`

### Minimum `functions.php` pattern

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

If the project later adds feature stylesheets or JS files, version those child assets with the same helper instead of the static theme version so browsers do not keep stale local copies during refinement.

### Suggested `.gitignore`

```text
# OS
.DS_Store
Thumbs.db

# Editor
.cursor/
.vscode/
.idea/

# Temporary context files
session-context.tmp.md
```

## WordPress Settings To Pre-Configure

- Permalinks: Post name
- Timezone: set the working timezone used for the project
- Discourage search engines: enabled
- Delete the default post, sample page, and default comment
- Remove the Hello Dolly and Akismet plugins
- Set a memorable admin user for the local environment

## `_project-context.md` Starter Template

Use the schema from `PROJECT_CONTEXT_TEMPLATE.md`, but leave values blank and include placeholder comments so each new project starts from an empty operational file.

````text
# PROJECT CONTEXT

- Project Name:
<!-- Fill in the client or site name -->
- Site Type:
<!-- Fill in business / portfolio / service / ecommerce-lite / other -->
- Primary Goal:
<!-- Fill in what the site must achieve -->
- Stack: Blocksy Pro + Blocksy Child + Meta Box AIO + MB Views
- Local Environment:
<!-- Fill in the LocalWP site name -->
- Production Host:
<!-- Fill in GridPane or other host -->
- Date Started:
<!-- Fill in YYYY-MM-DD -->

## 1. Brand Direction
- Vibe Words:
  -
  -
  -
- Palette Direction:
<!-- Fill in monochrome / one accent / full palette -->
- Font Direction:
<!-- Fill in the intended font direction -->
- Visual Notes:
  -
  -

## 2. Design Tokens
```css
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
- Palette Mapping:
  - `--theme-palette-color-1` =
  - `--theme-palette-color-2` =
  - `--theme-palette-color-3` =
  - `--theme-palette-color-4` =
  - `--theme-palette-color-5` =
  - `--theme-palette-color-6` =

## 3. Naming Conventions
- CPT slugs: kebab-case
- Field IDs: snake_case prefixed by content type keyword
- Field group IDs: snake_case
- MB Views: `view-{subject}-{context}`
- CSS classes: `.mv-{subject}` and `.mv-{subject}--{element}`

## 4. Content Model
### Pages
-

### CPTs
-

### Taxonomies
-

## 5. Field Schema Inventory
-

## 6. View Inventory
-

## 7. Placement Map
| Artifact | Source File | Live Object | Placement Type | Assigned Location | Conditions | Notes |
|----------|-------------|-------------|----------------|-------------------|------------|-------|
| | | | | | | |

## 8. Active Layout Patterns
-
-
-

## 9. Open Decisions
-

## 10. Current Build Priorities
1.
2.
3.
````

## Blocksy Customizer Pre-Configuration

Optional baseline choices for the saved blueprint:
- neutral palette that can be remapped per project
- Inter as the default font family that can be overridden later
- container max-width set to a sensible baseline such as 1200px
- minimal header and footer configuration
- sidebar disabled globally by default

## What Not To Include In The Blueprint

- paid plugin licenses activated
- real content, demo posts, or sample client data
- an initialized Git repository inside the child theme
- custom CSS or Twig carried over from another project

## Blueprint Verification Checklist

1. All required plugins are installed and activated except the child theme
2. The child theme folder exists with the scaffold files and `.gitkeep` placeholders
3. `_project-context.md` is in place with the blank starter template
4. Permalinks are set to Post name
5. Default content is deleted
6. The admin user is set
7. A test dummy page publishes successfully

## Usage On New Projects

1. Spin up a new LocalWP site from the blueprint
2. Activate the child theme
3. Run `git init` inside `blocksy-child/`
4. Push the child theme to a new private GitHub repository
5. Fill in `_project-context.md`
6. Run `@PROJECT_BOOTSTRAP_PROMPT.md run`

Use `d3-guides/GIT_WORKFLOW_GUIDE.md` for the exact point where Git enters the project and what the repository should track.
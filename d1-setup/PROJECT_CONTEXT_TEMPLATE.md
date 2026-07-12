# Project Context Template

Use this file as the canonical schema for each target project's `_project-context.md`.

```text
# PROJECT CONTEXT

- Project Name: [name]
- Site Type: [business / portfolio / service / ecommerce-lite / other]
- Primary Goal: [what the site must achieve]
- Stack: Blocksy Pro + Blocksy Child + Meta Box AIO + MB Views
- Local Environment: [LocalWP site name]
- Production Host: [GridPane or other]
- Date Started: [YYYY-MM-DD]
- Current Phase: [0 Intake / 1 Design direction / 2 Design handoff / 3 Bootstrap / 4 Token setup / 5 Content model / 6 Page build / 7 Refinement / 8 QA / 9 Deploy / 10 Maintenance]
- Design Source: [none / Claude Design / mockup / HTML export / existing site / other]
- Design Approval Status: [not started / draft / approved / needs revision]
- Client Editability: [Managed / Guided / Flexible / Builder]

## 1. Brand Direction
- Vibe Words:
  - [word]
  - [word]
  - [word]
- Palette Direction: [monochrome / one accent / full palette]
- Font Direction: [brief description]
- Visual Notes:
  - [short point]
  - [short point]

## 1a. Design Handoff
- Source Location: [URL / file path / notes]
- Claude Design Notes:
  - [note or none]
- Handoff Artifacts:
  - [screenshot / HTML export / asset folder / notes]
- Editable Surface Map:
  - [area] - [locked / fields / Gutenberg / builder / undecided]
  - [area] - [locked / fields / Gutenberg / builder / undecided]

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
  --mvs-type-body-desktop: var(--text-base);
  --mvs-type-body-tablet: var(--text-base);
  --mvs-type-body-mobile: var(--text-base);
  --mvs-type-h1-desktop: var(--text-4xl);
  --mvs-type-h1-tablet: var(--text-3xl);
  --mvs-type-h1-mobile: var(--text-2xl);
  --mvs-type-section-title-desktop: var(--text-3xl);
  --mvs-type-section-title-tablet: var(--text-2xl);
  --mvs-type-section-title-mobile: var(--text-xl);
}
```
- Runtime Typography Controls:
  - Status: [enabled / disabled / undecided]
  - Admin Location: `Appearance > MVS Typography`
  - Option Name: `mvs_typography_controls`
  - Controlled Roles: [body / paragraph / list_item / h1-h6 / page_title / section_title / card_title / button / meta]
  - Notes: [project-specific typography decisions or exceptions]
- Palette Mapping:
  - `--theme-palette-color-1` = [role]
  - `--theme-palette-color-2` = [role]
  - `--theme-palette-color-3` = [role]
  - `--theme-palette-color-4` = [role]
  - `--theme-palette-color-5` = [role]
  - `--theme-palette-color-6` = [role]

## 3. Naming Conventions
- CPT slugs: kebab-case
- Field IDs: snake_case prefixed by content type keyword
- Field group IDs: snake_case
- MB Views: `view-{subject}-{context}`
- CSS classes: `.mv-{subject}` and `.mv-{subject}--{element}`

## 4. Content Model
### Pages
- [page slug] - [goal]

### CPTs
- [cpt slug]
  - Purpose: [what it stores]
  - Single View: [view name]
  - Archive View: [view name]

### Taxonomies
- [taxonomy slug] - [role]

## 5. Field Schema Inventory
- `[file or group id]` - [what it stores]

## 6. View Inventory
- `[view name]` - Source: `[views/path]` - Scope: [single / archive / section / reusable]

## 7. Placement Map
| Artifact | Source File | Live Object | Placement Type | Assigned Location | Conditions | Notes |
|----------|-------------|-------------|----------------|-------------------|------------|-------|
| [hero] | [views/sections/home-hero.twig] | [Home Hero] | MB View | Page: Home | none | [notes] |

## 8. Active Layout Patterns
- Section wrapper
- Two-column grid
- Three-column card grid
- Featured split layout

## 9. Open Decisions
- [decision]

## 10. Current Build Priorities
1. [priority]
2. [priority]
3. [priority]
```

## Required Rules

- Keep this file in the target project root
- Keep `mvs-project-status.md` beside this file when long-break recovery or active project tracking is useful
- Update the placement map after every live assignment change
- Treat the token block as the canonical source for spacing, primitive type scale, and semantic typography defaults
- If runtime typography controls are enabled, keep the `Appearance > MVS Typography` settings limited to sanitized responsive `--mvs-type-*` overrides and record any intentional exceptions here
- Record the design source, design approval status, client editability level, and editable surface map before converting a visual design into MVS artifacts
- If the project tracks `.mbjson` without duplicate `.json` export twins, note the `mbb_json_files` bridge in `functions.php` so future sessions know how Meta Box local-file mode is being satisfied
- Do not let the only source of truth live in the WordPress admin

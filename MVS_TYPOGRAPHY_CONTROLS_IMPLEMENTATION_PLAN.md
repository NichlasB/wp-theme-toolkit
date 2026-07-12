# MVS Typography Controls Implementation Plan

Status: Implementation in progress
Created: 2026-07-09
Owner: Meta Views Stack / wp-theme-toolkit
Primary target: LocalWP `meta-views-stack` blueprint
Toolkit target: `wp-theme-toolkit`

## Purpose

Create a reusable typography control system for Meta Views Stack sites so common font-size changes can be handled from WordPress admin without requiring one-off code edits for every page, heading, paragraph, or section.

The system should preserve the MVS principle that design tokens and semantic roles stay legible in files while allowing approved runtime values to be adjusted through a controlled admin UI.

## Current Recommendation

Build MVS Typography Controls as a child-theme module in the Meta Views Stack blueprint, then update `wp-theme-toolkit` so future MVS projects scaffold, document, review, and maintain the same pattern.

Recommended UI location:

- `Appearance > MVS Typography`

Recommended storage:

- One WordPress option containing sanitized responsive typography settings.

Recommended frontend output:

- CSS custom properties printed after the static `tokens.css` layer.
- Static defaults remain in the child theme so the site works cleanly before any admin settings are saved.

## Architectural Decision Log

| Date | Decision | Rationale | Status |
|------|----------|-----------|--------|
| 2026-07-09 | Use a focused MVS admin screen rather than the WordPress Customizer for v1. | Blocksy already owns a large Customizer surface; an MVS-specific admin page gives clearer control over semantic roles without fighting theme options. | Accepted |
| 2026-07-09 | Keep static defaults in `assets/css/tokens.css`. | Git-backed defaults remain readable, portable, and reviewable. | Accepted |
| 2026-07-09 | Output saved settings as CSS variables, not generated selector rules. | Existing MVS CSS can consume semantic variables, and site CSS remains easier to audit. | Accepted |
| 2026-07-09 | Put runtime implementation in the blueprint and reusable guidance in the toolkit. | The blueprint needs the actual feature; the toolkit needs prompts, docs, and review rules so future sites inherit the system. | Accepted |

## Scope

### In Scope

- Admin settings page for common responsive typography roles.
- Desktop, tablet, and mobile values for each role.
- Sanitized numeric values with supported units.
- Reset-to-default behavior.
- Frontend CSS-variable output.
- Optional editor/admin preview support if it is lightweight.
- Toolkit documentation updates for tokens, prompts, and review checks.

### Out Of Scope For V1

- Font-family management, because Blocksy should continue to own global font selection.
- Per-page visual builder controls.
- Arbitrary CSS text areas.
- Live frontend drag handles or visual editing.
- Database migration automation beyond normal WordPress option transport.

## Proposed Typography Roles

Start with roles that map to real MVS usage rather than every possible HTML selector.

| Role Key | Label | Default Source | Notes |
|----------|-------|----------------|-------|
| `body` | Body text | `--text-base` | Sitewide default text size. |
| `paragraph` | Paragraph | `--text-base` | Can match body by default. |
| `list_item` | List item | `--text-base` | Useful when lists need tighter mobile control. |
| `h1` | H1 | `--text-4xl` | Global page-level heading. |
| `h2` | H2 | `--text-3xl` | Major content heading. |
| `h3` | H3 | `--text-2xl` | Section/card heading. |
| `h4` | H4 | `--text-xl` | Smaller structured heading. |
| `h5` | H5 | `--text-lg` | Minor heading. |
| `h6` | H6 | `--text-base` | Minor heading. |
| `page_title` | Page title | `--text-4xl` | Semantic role for templates and MB Views. |
| `section_title` | Section title | `--text-3xl` | Reusable section heading role. |
| `card_title` | Card title | `--text-xl` | Reusable card/listing role. |
| `button` | Button | `--text-base` | For custom MVS button components. |
| `meta` | Meta/small text | `--text-sm` | Dates, labels, helper text. |

## CSS Variable Contract

Use predictable semantic variables for each role and breakpoint.

```css
:root {
  --mvs-type-body-desktop: var(--text-base);
  --mvs-type-body-tablet: var(--text-base);
  --mvs-type-body-mobile: var(--text-base);
  --mvs-type-h1-desktop: var(--text-4xl);
  --mvs-type-h1-tablet: var(--text-3xl);
  --mvs-type-h1-mobile: var(--text-2xl);
}
```

Runtime settings should override only the relevant `--mvs-type-*` variables. Selectors should read from these variables in global base CSS and component CSS.

## Implementation Phases

### Phase 1 - Blueprint Discovery

Status: Completed

- [x] Confirm the blueprint child-theme root and current Git status.
- [x] Confirm whether the feature should be built into the child theme directly or packaged as a reusable mu-plugin/plugin module for future export.
- [x] Inventory current `tokens.css`, `base.css`, `components.css`, and `project.css` typography usage.
- [x] Identify where admin module files should live, likely `inc/typography-controls.php`.
- [x] Confirm whether any current Blocksy typography settings conflict with planned selectors.

### Phase 2 - Static Token Contract

Status: Completed

- [x] Add default `--mvs-type-*` variables to `assets/css/tokens.css`.
- [x] Update `assets/css/base.css` so global elements consume semantic typography variables.
- [x] Update reusable component CSS to consume semantic typography variables where appropriate.
- [x] Avoid removing existing `--text-*` scale tokens; keep them as primitive values.
- [x] Document any role-specific exceptions in `_project-context.md` if needed.

### Phase 3 - Admin Settings Module

Status: Completed

- [x] Add a focused typography controls module.
- [x] Register one option for saved typography settings.
- [x] Build an `Appearance > MVS Typography` admin page.
- [x] Provide desktop, tablet, and mobile inputs per role.
- [x] Add nonce, capability, sanitization, and validation.
- [x] Support reset to defaults.
- [x] Keep the UI compact enough for repeated real use.

### Phase 4 - Runtime CSS Output

Status: Completed

- [x] Generate CSS variables from saved settings.
- [x] Enqueue or print runtime CSS after `mvs-tokens`.
- [x] Keep output minimal when no saved settings exist.
- [x] Verify responsive variables apply at desktop, tablet, and mobile breakpoints.
- [x] Confirm cache/version behavior after settings save.

### Phase 5 - Local Verification

Status: Partially verified

- [ ] Verify wp-admin page loads without PHP notices.
- [ ] Save representative typography settings.
- [x] Confirm frontend CSS variables are generated by the PHP runtime path.
- [x] Confirm body, paragraphs, lists, headings, and MVS semantic roles are wired in CSS.
- [x] Check mobile, tablet, and desktop breakpoint variables in static CSS.
- [ ] Confirm reset returns to static defaults in wp-admin.

Note: browser/admin verification is pending because `mvs.local` and direct LocalWP port `127.0.0.1:10011` timed out during HTTP checks on 2026-07-09.

### Phase 6 - Toolkit Updates

Status: Completed

- [x] Update `d3-guides/DESIGN_SYSTEM_GUIDE.md` with the runtime typography token layer.
- [x] Update `d1-setup/STACK_REFERENCE.md` with the module boundary and token contract.
- [x] Update `d1-setup/PROJECT_CONTEXT_TEMPLATE.md` so projects record typography-control decisions.
- [x] Update `d4-prompts/ds2-build/DESIGN_TOKENS_PROMPT.md` so future sites scaffold semantic responsive type roles.
- [x] Update review prompts to flag raw font-size values that bypass the new role system.
- [x] Update examples if needed.

### Phase 7 - Final Documentation And Handoff

Status: Not started

- [ ] Update this implementation plan with final file paths, verification notes, and open follow-ups.
- [ ] Summarize what belongs to blueprint code vs toolkit docs.
- [ ] Confirm whether changes should be committed, tagged, or left as working-tree changes.
- [ ] Create a concise usage note for future chats.

## Acceptance Criteria

- A non-developer admin can adjust common font sizes for desktop, tablet, and mobile.
- The frontend remains token-driven and does not require one-off selector edits for normal typography tuning.
- Static defaults are stored in Git-backed child-theme files.
- Runtime overrides are sanitized and limited to expected CSS size values.
- MVS prompts and review docs teach future work to use the typography role system.
- Existing Blocksy typography ownership remains clear: Blocksy handles font families; MVS handles semantic responsive size roles.

## Open Decisions

- Should the blueprint implement this directly in the child theme, or as a reusable companion plugin/mu-plugin that sites can copy forward?
- Should v1 include line-height and letter-spacing controls, or only font size?
- Should controls use free numeric inputs, select menus from token steps, or both?
- Should page-specific overrides exist in v1, or should v1 stay global-only?
- Should runtime CSS also be loaded in the block editor for closer admin preview parity?

## Progress Log

| Date | Update |
|------|--------|
| 2026-07-09 | Created initial implementation plan from the selected approach: blueprint runtime module plus toolkit documentation/scaffold updates. |
| 2026-07-09 | Implemented blueprint semantic typography variables, global/component CSS consumption, `inc/typography-controls.php`, and toolkit documentation updates. Verification is in progress. |
| 2026-07-09 | PHP lint passed for `functions.php` and `inc/typography-controls.php`; PHP-level smoke test passed for sanitization and runtime CSS generation. Browser/admin verification is pending because LocalWP HTTP timed out. |

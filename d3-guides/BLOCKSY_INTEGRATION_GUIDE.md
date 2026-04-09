# Blocksy Integration Guide

This guide defines how Blocksy Pro and MB Views work together in the Meta Views Stack.

## Rule Of Thumb

Blocksy owns the layout shell.

MB Views owns the content area inside that shell.

Blocksy Content Blocks bridge the two when custom output needs to appear in Blocksy's layout zones.

## Decision Matrix

| Need | Approach |
|------|----------|
| Standard layout with widgets, menus, columns | Pure Blocksy |
| Mostly Blocksy plus one custom-designed section | Blocksy plus HTML widget with AI-generated code |
| Custom block reused across multiple pages | Blocksy Content Block |
| Fully custom layout with editable fields | MB View plus Settings Page assigned through a Content Block |
| Layout pulling dynamic data such as live counts or taxonomy-aware output | MB View with Twig queries |
| Replace the main content area of a single or archive | MB View with location rules |

## Assignment Recording Rule

Every live assignment must be written to the placement map in `_project-context.md`.

Record:
- source file path
- live view name or content block name
- placement type
- assigned location
- conditions
- notes

## Blocksy Variables

Blocksy palette variables are available to view CSS and should be the only color source for MB Views.

Examples:

```css
background: var(--theme-palette-color-6);
color: var(--theme-palette-color-1);
```

## Content Blocks And MB Views Together

These tools are often combined:

1. MB View renders the data-driven card, hero, or archive markup
2. Blocksy Content Block controls where the object appears
3. `_project-context.md` records the relationship

## Recommended Working Pattern

1. Build the data schema first
2. Generate the MB View Twig and CSS
3. Create the live MB View in WordPress admin
4. Apply location rules or place it through a Content Block
5. Record the assignment immediately

## Sidebar Ownership

Rule:

Blocksy owns the layout shell. MB Views owns the content area. Blocksy Content Blocks bridge the two when custom output needs to appear in Blocksy's layout zones.

Practical breakdown:
- Blocksy controls the header, footer, sidebar slot, container width, and responsive layout collapse
- MB Views controls the content area inside Blocksy's layout, which is effectively the `<main>` region
- Blocksy Content Blocks inject MB Views or other custom output into Blocksy's layout zones such as before content, after content, sidebar, header, and footer

Configuration location:
- sidebar visibility, position, width, sticky behavior, and responsive collapse all belong in the Blocksy Customizer, not in MB Views

What goes in a sidebar:
- standard WordPress widgets such as search, recent posts, and categories
- plugin widgets such as WP Grid Builder facets or a Fluent Forms widget
- custom HTML via a Blocksy Content Block placed in the sidebar zone

Build a fake sidebar inside an MB View only when the sidebar content is tightly tied to the current post's own data, such as a specifications panel beside a listing. In that case, use a two-column CSS Grid layout and treat the sidebar as a template column, not as a real theme sidebar.

| Need | Use |
|------|-----|
| Standard sidebar with widgets | Blocksy sidebar in Customizer |
| Sidebar with plugin widgets | Blocksy sidebar plus widget |
| Custom HTML in sidebar | Blocksy Content Block placed in the sidebar zone |
| Sidebar content derived from the post's own fields | Two-column MB View using CSS Grid |
| No sidebar at all | Disable the sidebar in Blocksy for that template |

## HTML Widget Escape Hatch

Pattern:

Blocksy's footer, header, and sidebar zones all support HTML widgets. You can paste AI-generated HTML and CSS directly into these widgets to get custom-designed output without building a full MB View or Content Block.

Use it when:
- a single footer column needs a custom design such as a newsletter signup, contact block, or trust badges row
- a header zone needs a custom CTA or announcement beyond Blocksy's built-in elements
- a sidebar needs a one-off custom block alongside standard widgets
- the content is static and changes rarely

Do not use it when:
- the content needs to be edited through Meta Box fields
- the content pulls dynamic data from posts or queries
- the same block needs to appear in multiple places, in which case a Content Block is the better reusable surface
- the block is large or complex enough to deserve its own template file in Git

Trade-off:

HTML widgets are static. Their content lives in the database, not in a Git-tracked file and not in Meta Box fields. For small footer, header, or sidebar touches that rarely change, that trade-off is usually acceptable.

Workflow:
1. Describe the custom block to the AI
2. Generate self-contained HTML and CSS, using an inline `<style>` tag when helpful
3. Add an HTML widget to the correct Blocksy zone through the Customizer
4. Paste the code
5. Save and preview

Cross-reference:
- this pattern applies equally to footer, header, and sidebar zones
- use it as the fast path for static custom output before escalating to a Content Block or MB View

Important constraint for the AI:
- generate self-contained HTML and CSS that does not depend on external files, child-theme styles, or design-token declarations
- scope the CSS tightly to a unique widget prefix to avoid collisions
- prefer Blocksy palette variables such as `var(--theme-palette-color-1)` where they keep the widget visually aligned with the active theme

## Common Mistakes

- using Blocksy Content Blocks as a substitute for data modeling
- leaving the assignment logic undocumented in files
- styling views with hardcoded colors instead of Blocksy palette variables
- duplicating the same data-driven section in multiple Content Blocks without a shared local reference copy
- trying to make MB Views own the theme sidebar shell instead of letting Blocksy manage it
- pasting static custom widget code into the database without noting the decision in project context when it matters operationally
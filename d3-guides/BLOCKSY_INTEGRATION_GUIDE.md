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
| Sitewide custom footer or header that should stay Git-tracked | Blocksy Footer/Header Template Content Block plus MB Views shortcode or file-backed view |
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

## Theme Variables And Specificity

When a style change appears to do nothing, do not assume the child stylesheet failed to load.

Check the live computed styles first.

Common Blocksy or WordPress patterns:
- theme-wide behaviors can be driven by Blocksy variables and selectors such as `body ::selection`
- WordPress comments and other shared surfaces can use high-specificity selectors such as `#reply-title`
- the browser may still be serving stale child-theme CSS or JS if asset versions never change during local development

Working rule:
1. Inspect the live selector and computed styles in DevTools
2. If the parent theme is styling through Blocksy variables, override those variables in the shared child-theme layer such as `style.css` or another globally loaded stylesheet
3. If the parent theme is styling through a more specific selector, match or exceed that specificity in the child theme and keep the override scoped to the intended surface
4. If the rule still does not update, verify the child asset URL changes when the file changes instead of using only the static theme version header

Use this pattern for global states such as text selection and for theme-owned UI such as comment headings, not just for page-section CSS.

## Content Blocks And MB Views Together

These tools are often combined:

1. MB View renders the data-driven card, hero, or archive markup
2. Blocksy Content Block controls where the object appears, including dedicated Header Template and Footer Template assignments
3. `_project-context.md` records the relationship

## Recommended Working Pattern

1. Build the data schema first
2. Generate the MB View Twig and CSS
3. Create the live MB View in WordPress admin
4. Apply location rules or place it through a Content Block
5. Record the assignment immediately

## Footer And Header Templates

Pattern:

For a sitewide custom footer or header, prefer Blocksy's dedicated Footer Template or Header Template content block instead of a page-scoped MB View or a large database-only HTML block.

Recommended setup:
1. Keep the Blocksy Content Block thin and treat it as the placement layer
2. Keep the real Twig, CSS, and JS in the child theme or site repo
3. Render that file-backed output through an MB Views shortcode or a live MB View
4. Record both the Content Block name and the underlying source file in `_project-context.md`

If the project registers `mbv_fs_paths`, MB Views can render a child-theme Twig file directly from a Shortcode block inside the template, for example:

```text
[mbv name="sections/site-footer.twig"]
```

Use this when:
- the footer or header needs custom layout but should remain globally owned by Blocksy
- the markup should stay Git-tracked instead of living only in WordPress admin
- the same object will be refined repeatedly over time

Do not use this pattern when a small static HTML widget is enough.

## Full-Width MB Views

When an MB View replaces the main content area, it still renders inside Blocksy's content shell.

If the design should break edge to edge, add `alignfull` to the outermost wrapper of the view, for example:

```twig
<main class="mv-home alignfull">
	...
</main>
```

Use this only when the design intentionally needs to break out of the constrained content width.

Check the live markup if a view still looks capped unexpectedly. A common cause is the default WordPress or Blocksy constrained wrapper around `.entry-content`, which will keep the custom view narrow until the root element is treated as full width.

This applies inside Blocksy Content Blocks and Footer/Header Templates as well. Those surfaces often render inside a Gutenberg constrained wrapper, so a full-bleed section still needs `alignfull` on the outermost element, for example:

```twig
<section class="mv-site-footer alignfull">
	...
</section>
```

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
- forgetting `alignfull` on a root view wrapper when a replacement-content MB View is supposed to render full width
- assuming a Footer Template or other Content Block automatically escapes Gutenberg's constrained width without `alignfull`
- putting the only copy of a global footer or header layout inside the Blocksy Content Block instead of keeping the source in a tracked file
- pasting static custom widget code into the database without noting the decision in project context when it matters operationally
- trying to override a Blocksy theme variable such as selection color only from page-level CSS instead of setting the underlying shared variable
- assuming a child-theme CSS change failed when the real issue is a stale asset URL or a parent selector with higher specificity such as `#reply-title`
# Blocksy Integration Guide

This guide defines how Blocksy Pro and MB Views work together in the Meta Views Stack.

## Rule Of Thumb

MB Views defines the template output.

Blocksy Content Blocks define where that output appears in the page structure.

## Decision Matrix

| Scenario | Use | Why |
|----------|-----|-----|
| Replace the main single or archive content body | MB Views location rules | The view is the template itself |
| Add a section above or below the existing content | Blocksy Content Block | Placement is the main concern |
| Show different sections for the same CPT based on taxonomy or context | Blocksy Content Block with conditions | Conditional placement is easier to manage there |
| Global CTA, announcement bar, or repeated site-wide section | Blocksy Content Block | This is a global layout concern |
| Render Meta Box field data inside the main content body | MB View | The content model belongs in the view |

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

## Common Mistakes

- using Blocksy Content Blocks as a substitute for data modeling
- leaving the assignment logic undocumented in files
- styling views with hardcoded colors instead of Blocksy palette variables
- duplicating the same data-driven section in multiple Content Blocks without a shared local reference copy
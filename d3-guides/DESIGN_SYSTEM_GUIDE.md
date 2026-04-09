# Design System Guide

This guide defines the shared frontend system for all sites built with `wp-theme-toolkit`.

It is the authoritative reference for spacing, typography, layout, color usage, naming, and responsive behavior.

## Core Principle

Build a small, explicit system and reuse it everywhere.

The design system should make new MB Views easier to generate and easier to review. It should not become a second theme framework.

## Token Layer

Define the canonical token block in the child theme `style.css`.

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

Rules:
- View CSS may consume these variables, but should not redefine them
- View CSS must not introduce raw spacing values for component padding, gaps, margins, or section rhythm
- View CSS must not introduce raw font-size values outside the documented token set unless there is an explicit project decision recorded in `_project-context.md`

## Color Rules

Use only Blocksy palette variables in view CSS:

```css
color: var(--theme-palette-color-1);
background-color: var(--theme-palette-color-6);
border-color: var(--theme-palette-color-3);
```

Rules:
- Never use hex values in view CSS
- Never use `rgb()`, `rgba()`, `hsl()`, or named colors in view CSS
- If a new color role is needed, map it to an existing Blocksy palette slot and record the meaning in `_project-context.md`

## Typography Rules

Use the documented token steps for type size and rely on Blocksy's global font-family settings for font selection.

Recommended usage:

```css
.mv-hero--eyebrow {
  font-size: var(--text-sm);
}

.mv-hero--title {
  font-size: var(--text-4xl);
}

.mv-hero--body {
  font-size: var(--text-lg);
}
```

Rules:
- One hero title size per page section, not multiple competing display sizes
- Avoid setting line-height numerically unless the content genuinely needs it
- Body copy should usually be `var(--text-base)` or `var(--text-lg)`

## Layout Patterns

Use a small set of repeatable patterns.

### Section wrapper

```css
.mv-section {
  max-width: var(--content-max-width);
  margin: 0 auto;
  padding: var(--space-xl) var(--space-md);
}
```

### Narrow content wrapper

```css
.mv-section--narrow {
  max-width: var(--content-narrow-width);
  margin: 0 auto;
  padding: var(--space-xl) var(--space-md);
}
```

### Two-column layout

```css
.mv-grid--two-col {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-lg);
}

@media (max-width: 900px) {
  .mv-grid--two-col {
    grid-template-columns: 1fr;
  }
}
```

### Three-column card grid

```css
.mv-grid--cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--space-lg);
}

@media (max-width: 900px) {
  .mv-grid--cards {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 600px) {
  .mv-grid--cards {
    grid-template-columns: 1fr;
  }
}
```

### Split hero layout

```css
.mv-hero {
  display: grid;
  grid-template-columns: 1.1fr 0.9fr;
  gap: var(--space-xl);
  align-items: center;
}

@media (max-width: 900px) {
  .mv-hero {
    grid-template-columns: 1fr;
  }
}
```

Rules:
- Use Grid for two-dimensional layout
- Use Flexbox for one-dimensional alignment only
- Never use floats for layout

## Multi-Section Page Pattern

Rule:

One field group, one MB View, all sections in a single Twig template.

Each page section should be a real `<section>` element inside the same view, not a separate MB View, when the sections belong only to that page.

Follow this rule when:
- the page contains multiple distinct content sections that belong to one page, such as a homepage, about page, or services page
- the sections are unique to that page and are not expected to be reused elsewhere

Split into separate views when:
- a section needs to be reused on other pages, in which case it should move to its own view and be assigned through a Blocksy Content Block
- the page grows beyond roughly 8 sections or the Twig file becomes difficult to scan, in which case split by logical grouping

Field naming convention:

```text
hero_headline, hero_subheadline, hero_cta_text, hero_cta_url, hero_bg_image
features_heading, features_intro, features_items
testimonial_quote, testimonial_author, testimonial_photo
cta_heading, cta_button_text, cta_button_url
```

Prefix every field with its section name so the WordPress editor groups fields visually and the Twig template remains readable.

Twig structure convention:

```twig
{# ── Hero ── #}
<section class="mv-home--hero">
  ...
</section>

{# ── Features ── #}
<section class="mv-home--features">
  ...
</section>

{# ── Testimonial ── #}
<section class="mv-home--testimonial">
  ...
</section>

{# ── CTA Banner ── #}
<section class="mv-home--cta">
  ...
</section>
```

CSS organization convention:
- organize the view CSS by section with matching comment dividers
- keep section-specific styles together instead of scattering them across the file
- keep the class naming aligned to `.mv-{page}--{section}` and `.mv-{page}--{section}-{element}`

Cross-reference:
- see `TWIG_PATTERNS_GUIDE.md` for the Twig-side shorthand rule
- see `IMAGE_ASSET_WORKFLOW.md` when a hero, card, or CTA section depends on isolated transparent PNG assets

## Component Naming Convention

Every section or component uses the `.mv-{name}` prefix.

Examples:
- `.mv-team`
- `.mv-team--card`
- `.mv-team--bio`
- `.mv-team--card.is-active`

Rules:
- The component root uses `.mv-{name}`
- Child elements use `.mv-{name}--{element}`
- State classes use `.is-*`
- Do not mix BEM fragments from unrelated components in the same view

## Spacing Rules

Only use the spacing token scale:

```css
gap: var(--space-lg);
padding: var(--space-xl) var(--space-md);
margin-top: var(--space-sm);
```

Rules:
- No raw `px`, `rem`, `em`, or `%` values for spacing in view CSS
- Use `var(--space-md)` as the default small rhythm unit
- Use `var(--space-xl)` or `var(--space-2xl)` for section rhythm

## Responsive Rules

Only two breakpoints are supported in v1:

```css
@media (max-width: 900px) { /* tablet */ }
@media (max-width: 600px) { /* mobile */ }
```

Rules:
- Do not introduce `768px`, `1024px`, or one-off breakpoints into view CSS
- Collapse multi-column layouts at `900px`
- Move to single-column mobile stacking by `600px` when needed

## Semantic Markup Rules

- Use real headings in order
- Use `section`, `article`, `ul`, `ol`, `figure`, `figcaption`, and `nav` when they fit the content
- Buttons are for actions, links are for navigation
- Decorative images should not receive misleading alt text

## Required Review Checks

Every generated view should pass these checks:
- only design-system spacing tokens used
- only Blocksy palette variables used
- only the two supported breakpoints used
- no floats
- naming convention followed
- semantic HTML present

## Prohibited Practices

- hardcoded colors in view CSS
- raw spacing values in view CSS
- ad hoc breakpoint values
- inline style attributes for layout or color
- duplicated near-identical class systems between views
- mixing Grid and Flexbox unnecessarily in the same layout layer
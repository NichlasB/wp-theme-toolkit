# Element To LLM Workflow

This guide defines the refinement loop for visual adjustments after the first MB View render exists.

## When To Use It

Use Element to LLM after:
- the first Twig and CSS pass exists
- the page is rendered in the browser
- you need to refine spacing, hierarchy, alignment, wrapping, or responsive behavior against the real DOM and computed styles

## Standard Loop

1. Generate the first Twig and CSS pass
2. Paste it into MB Views
3. Open the local page in the browser
4. Capture the relevant section with Element to LLM
5. Paste the capture into chat with a concrete refinement request
6. Update the Twig and CSS only where needed
7. Paste the revised code back into MB Views
8. Update the local reference copy in `views/`

## Good Prompt Shape

Provide:
- the exact section you captured
- the intended visual goal
- any constraints from the design system
- whether the issue is desktop, tablet, mobile, or all three

Example:

```text
Refine this homepage hero.
Goal: stronger hierarchy, tighter text column, better image balance.
Constraints: use only design-system tokens, Blocksy palette variables, and the 900/600 breakpoints.
Return updated Twig and CSS only.
```

## What To Look For In The Capture

- wrappers that are too wide or too narrow
- inconsistent gap rhythm
- typography that ignores the token scale
- over-nested markup
- image ratio or overflow issues
- responsive collapse problems

## Output Rule

Always request updated Twig and CSS, not prose-only commentary.

## File Hygiene Rule

After applying a successful refinement:
- update the live MB View
- update the local reference copy in `views/`
- update `_project-context.md` if the refinement changed pattern decisions
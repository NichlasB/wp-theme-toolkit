<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Page Scoping Checklist Prompt

Use this prompt at the start of a new page request before `NEW_PAGE_PROMPT.md`.

---

## Purpose

Run this when you need to decide the right Meta Views Stack shape for a normal website page.

Use it to classify the page as:
- a page-level MB View
- a page-level MB View plus one or more reusable section views
- a CPT-backed page
- a hybrid page with static Twig plus a small field model

Do not use this prompt when the content type is already clearly a CPT. Use `NEW_CPT_PROMPT.md` instead.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `_project-context.md` in the target project when it exists
- `d3-guides/PAGE_DECISION_TREE_CHEAT_SHEET.md`
- `d3-guides/PAGE_BUILDING_WORKFLOW.md`
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`

---

## Required Inputs

- page name or slug
- page goal
- rough section list or mockup summary
- what the editor must be able to change in wp-admin
- which sections may be reused elsewhere
- whether any list or card content may later need its own URLs, archives, or taxonomies

If a mockup exists, treat it as a layout reference first and decide the content model second.

---

## Checklist

### 1. Classify the page shell
- decide whether the page mostly belongs to one URL only
- decide whether the page should start as one MB View with multiple `<section>` blocks
- flag any sections that already look reusable or placement-driven

### 2. Classify each section
For each section, choose one:
- static Twig
- page-targeted field(s)
- reusable section view
- CPT-backed content

Use these rules:
- static Twig for stable copy, decorative structure, and layout-only wrappers
- page fields for editable copy, images, CTAs, shortcodes, and repeaters that belong only to this page
- reusable section views for sections repeated across pages or controlled by Blocksy placement rules
- CPT-backed content for items that need many entries, archives, single templates, taxonomies, or separate URLs

### 3. Decide whether a CPT is actually needed
- if the content needs many entries, its own URLs, archives, or taxonomies, recommend a CPT
- otherwise keep it as a normal page build
- explicitly call out false positives, such as service cards that look structured but still belong to one marketing page

### 4. Decide the minimal field model
- add fields only where editor control is useful
- avoid creating fields for every paragraph
- prefer section-prefixed field names
- identify likely repeaters such as FAQs, pricing tiers, feature cards, stats, or steps

### 5. Decide the output artifact shape
- whether the page should have one `.mbjson` file
- whether the page should have one local Twig reference file and one CSS file
- whether any reusable section files under `views/sections/` are warranted
- whether `NEW_PAGE_PROMPT.md` or `NEW_CPT_PROMPT.md` should be the next build workflow

---

## Required Output

Return a compact planning summary in this format:

```text
Page: [name or slug]
Recommended model: [page-level MB View / page-level MB View + reusable sections / CPT-backed page / hybrid page]
Section decisions:
- [section] - [static Twig / page fields / reusable section / CPT-backed]
- [section] - [decision]
Field model: [none / light / moderate / heavy]
Likely repeaters:
- [repeater or none]
Split-out sections:
- [section or none]
CPT warning:
- [none / what should become a CPT and why]
Next workflow: [@NEW_PAGE_PROMPT.md run / @NEW_CPT_PROMPT.md run]
```

Keep the answer short and operational. This is a scoping pass, not the full build.

## Worked Example

Example input:

```text
Page: About
Goal: explain the brand story, build trust, and lead visitors to contact
Sections: hero, founder story, values grid, short timeline, CTA band
Editor must change: hero copy, founder photo, founder story, values, timeline items, CTA text and link
Reusable elsewhere: CTA band might later appear on Services and Contact
Future CPT needs: none
```

Example output:

```text
Page: about
Recommended model: page-level MB View + reusable sections
Section decisions:
- hero - page fields
- founder story - page fields
- values grid - page fields
- timeline - page fields
- CTA band - reusable section
Field model: moderate
Likely repeaters:
- values_items
- timeline_items
Split-out sections:
- CTA band
CPT warning:
- none
Next workflow: @NEW_PAGE_PROMPT.md run
```

Why this is the right shape:
- the page belongs to one URL only
- the content is structured but does not need its own archive or single URLs
- the CTA band is the only likely reusable section
- a CPT would be unnecessary overhead for this page

---

## Constraints

- default to the smallest workable model
- do not recommend a CPT unless the content clearly wants its own lifecycle
- do not split page-unique sections into separate views without a reuse or placement reason
- do not create fields for stable copy with no editorial value
- treat mockups as layout evidence, not automatic field requirements

---

Run the page scoping checklist now and recommend the correct build shape.
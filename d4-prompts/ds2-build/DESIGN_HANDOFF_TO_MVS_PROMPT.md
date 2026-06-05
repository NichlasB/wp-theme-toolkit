<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Design Handoff To MVS Prompt

Use this prompt to convert a Claude Design export, screenshot, mockup, HTML bundle, existing-site capture, or design brief into a Meta Views Stack implementation plan.

---

## Purpose

Run this when:
- the visual design exists before the MVS build
- the user has a Claude Design project or export
- the user has screenshots, HTML, a handoff bundle, or a design brief
- a design needs to be mapped into tokens, sections, fields, MB Views, CPTs, assets, and editable zones

Do not use this prompt to build the final page files directly. Use it to create the conversion plan and route to the correct build prompt.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `START_HERE_MASTER_WORKFLOW.md`
- `_project-context.md` in the target project when it exists
- `mvs-project-status.md` in the target project when it exists
- `d3-guides/CLAUDE_DESIGN_HANDOFF_WORKFLOW.md`
- `d3-guides/PAGE_BUILDING_WORKFLOW.md`
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`
- `d3-guides/PAGE_DECISION_TREE_CHEAT_SHEET.md`

---

## Required Inputs

- design source type: Claude Design, mockup, screenshot, HTML export, existing site, or other
- page or screen being converted
- target project or child-theme root
- client editability level: Managed, Guided, Flexible, or Builder
- available handoff material

If inputs are missing, ask at most 5 questions and stop.

---

## Workflow

### 1. Classify the design source
- identify whether the source is a concept, approved design, HTML export, or partial reference
- note whether desktop and mobile variants are present
- note any missing assets, unclear sections, or unresolved brand decisions

### 2. Extract the implementation inventory
- list pages
- list page sections in order
- identify reusable sections
- identify forms, media, testimonials, FAQs, pricing, service cards, and CTAs
- identify likely CPT candidates

### 3. Map design intent to MVS
- map color and typography implications to the token workflow
- classify each section as static Twig, page fields, reusable section, CPT-backed, or Gutenberg-guided
- choose the smallest workable content model
- identify editable, guided, locked, and builder-only areas

### 4. Update planning artifacts when available
- update `_project-context.md` with design source, editability, section decisions, and open decisions when the project context exists
- update or recommend creating `mvs-project-status.md`
- do not create final Twig, CSS, PHP, or `.mbjson` implementation files in this workflow

### 5. Route to the next build workflow
- token changes needed -> `@DESIGN_TOKENS_PROMPT.md run`
- page shape unclear -> `@PAGE_SCOPING_CHECKLIST_PROMPT.md run`
- normal page ready -> `@NEW_PAGE_PROMPT.md run`
- real content type needed -> `@NEW_CPT_PROMPT.md run`

---

## Constraints

- do not paste exported HTML directly into WordPress as the final implementation
- do not recommend Elementor or another page builder unless the editability level is `Builder`
- do not create fields for every paragraph
- do not create a CPT unless the content needs its own lifecycle
- do not split every section into separate MB Views
- do not treat a visual mockup as an automatic field schema

---

## Required Output

```text
Design source: [Claude Design / mockup / screenshot / HTML export / existing site / other]
Handoff quality: [complete / usable / partial / insufficient]
Client editability: [Managed / Guided / Flexible / Builder]
Recommended model: [summary]
Token impact:
- [impact or none]
Section decisions:
- [section] - [static Twig / page fields / reusable section / CPT-backed / Gutenberg-guided]
- [section] - [decision]
CPT candidates:
- [candidate or none]
Editable surface map:
- [area] - [locked / fields / Gutenberg / builder]
Assets needed:
- [asset or none]
Open decisions:
- [decision or none]
Next workflow:
`@[prompt filename] run`
```

Keep the answer operational. The next workflow should be obvious.

Proceed with the design handoff conversion now.

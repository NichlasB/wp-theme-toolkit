# Page Decision Tree Cheat Sheet

Use this for normal website pages in the Meta Views Stack.

## Fast Decision Tree

```text
Start
|
+-- Does this content need many entries, its own URLs, archives, or taxonomies?
|   |
|   +-- Yes -> Build a CPT. Use @NEW_CPT_PROMPT.md run.
|   |
|   +-- No -> Keep it as a normal page.
|
+-- Does the page mostly belong to one URL only?
|   |
|   +-- Yes -> Build one page-level MB View.
|   |
|   +-- No -> Split the reusable part into a section view.
|
+-- Does the editor need to change this content in wp-admin?
|   |
|   +-- Yes -> Add page-targeted fields only for those parts.
|   |
|   +-- No -> Keep it static in Twig.
|
+-- Is a section reused on other pages or controlled by placement rules?
    |
    +-- Yes -> Move that section to views/sections/ and place it with a Blocksy Content Block when needed.
    |
    +-- No -> Keep it inside the main page Twig file.
```

## Practical Default

If you are unsure, start here:
- one page
- one field group
- one MB View
- one Twig file with all page-unique sections
- one CSS file
- split only reused sections
- promote to CPT only when the content wants its own lifecycle

## Quick Page Heuristics

- About -> one page-level MB View
- Contact -> one page-level MB View, usually hybrid static plus a few fields
- Services -> page-level view unless each service needs its own page
- Pricing -> page-level view with repeaters
- FAQ -> page-level view unless FAQs are reused widely

## Mockup Workflow

If you have AI-generated mockups:
- give me the mockup
- tell me what must stay editable
- tell me what may be reused
- I will map it into static Twig, page fields, reusable sections, or CPT-backed content

If the page shape is still unclear, run `@PAGE_SCOPING_CHECKLIST_PROMPT.md run` before `@NEW_PAGE_PROMPT.md run`.

## Output Expectation

For most normal pages, the target artifact set is:
- one `.mbjson` file when fields are needed
- one local Twig reference file
- one local CSS reference file
- one live MB View assignment
- one placement map entry

Read `d3-guides/PAGE_BUILDING_WORKFLOW.md` when the page needs a fuller modeling decision.
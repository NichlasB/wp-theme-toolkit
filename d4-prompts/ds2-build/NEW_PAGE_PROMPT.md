<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# New Page Prompt

Use this prompt to add a new page section or page-level build to an existing Meta Views Stack project.

---

## Purpose

Run this when you need to create a new page or a significant new MB View section for an existing page.

Do not use this prompt when the real task is a new structured content type. Use `NEW_CPT_PROMPT.md` for that.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `_project-context.md` in the target project
- `d3-guides/PAGE_BUILDING_WORKFLOW.md`
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`
- `d3-guides/TWIG_PATTERNS_GUIDE.md`
- `d3-guides/BLOCKSY_INTEGRATION_GUIDE.md`
- `d3-guides/WORKFLOW_QUICK_REFERENCE.md`

---

## Required Inputs

- page goal
- page slug or location
- whether the page needs new fields or can reuse existing data
- any required CTA, media, testimonial, or form section

If the page brief is vague, clarify the content structure before generating files.

---

## Required Outputs

Create or update as needed:
- `_project-context.md`
- a local Twig reference file under `views/`
- a local CSS reference file under `views/` or paired reference notes
- a `.mbjson` file when new fields are required
- `functions.php` when the project uses tracked `.mbjson` schemas without duplicate `.json` copies and still needs the `mbb_json_files` bridge
- the placement map entry for the new page artifact

If live MB View creation is part of the task, keep the file copy as the source-of-truth reference even if the final paste happens in WordPress admin.

---

## Build Checklist

### 1. Define the page structure
- define the section order in plain language first
- identify whether the page is largely static, field-driven, or mixed
- choose whether the work should become a full page view, a reusable section, or both

### 2. Decide whether new fields are required
- reuse existing fields where practical
- add new `.mbjson` only when the content really needs structured data
- if the project keeps `.mbjson` only, confirm `functions.php` exposes those files to Meta Box Builder through `mbb_json_files`
- avoid creating fields for content that is simpler as static view markup

### 3. Generate the view artifacts
- generate Twig markup using the naming rules
- decide whether field output comes from the main-query `post.*` context or explicit `mb.rwmb_meta()` lookups
- do not output normal custom fields as `mb.field_id`
- generate CSS that only uses the token system and Blocksy palette variables
- keep the markup semantic and the layout patterns aligned to the design system

### 4. Record the assignment plan
- state whether the page view will use MB Views location rules or a Blocksy Content Block
- update the placement map entry
- ensure the local reference file path is recorded in `_project-context.md` when appropriate

### 5. Validate the result
- confirm no hardcoded colors are introduced
- confirm no off-scale spacing values are introduced
- confirm only `900px` and `600px` breakpoints are used
- confirm any new `.mbjson` fields will still load in wp-admin when `mb-json/` exists and `.json` twins are intentionally ignored

---

## Constraints

- no hardcoded colors
- no off-scale spacing values
- no extra breakpoints beyond `900px` and `600px`
- no undocumented placement decisions
- no undocumented local reference files
- no mixing of single-view and archive context patterns without reason

---

## Output Format

```text
Page: [name or slug]
Files created: [count]
Files updated: [count]
Artifacts:
- [path] - [purpose]
- [path] - [purpose]
Placement decision: [MB View location rule / Blocksy Content Block]
Field model impact: [none / new fields added / existing fields reused]
Follow-up review: [prompt name or none]
```

Proceed with the new page build now.
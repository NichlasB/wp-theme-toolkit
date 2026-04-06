<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# New CPT Prompt

Use this prompt to add a new custom post type and its associated Meta Box artifacts to a Meta Views Stack project.

---

## Purpose

Run this when the site needs a structured content type such as Team Members, Services, Case Studies, or Testimonials.

Do not use this prompt for a mostly static landing page. Use `NEW_PAGE_PROMPT.md` instead.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `_project-context.md` in the target project
- `d1-setup/STACK_REFERENCE.md`
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`
- `d3-guides/TWIG_PATTERNS_GUIDE.md`
- `d3-guides/BLOCKSY_INTEGRATION_GUIDE.md`
- `d3-guides/WORKFLOW_QUICK_REFERENCE.md`

Treat `_project-context.md` as the naming and modeling source of truth unless the user explicitly asks to change the schema.

---

## Required Inputs

- CPT purpose
- CPT slug when already decided
- whether a related taxonomy is needed
- required fields, repeaters, media, and CTA surfaces
- whether the CPT should launch with both single and archive views immediately

---

## Required Outputs

Create or update:
- `inc/cpt.php`
- one or more `.mbjson` files in `mb-json/`
- local reference Twig and CSS files for the single and archive views
- `_project-context.md`
- placement map entries for both single and archive usage

If the CPT also needs a reusable card or section fragment, save the local reference copy under `views/reference/` or another documented local path.

---

## Checklist

### 1. Model the content type
- choose a stable CPT slug
- define the field set with stable field IDs
- define any repeaters or groups
- decide whether a taxonomy is required now or can be deferred

Naming rules:
- CPT slug: kebab-case
- field IDs: snake_case prefixed by the CPT keyword
- field group IDs: snake_case
- view names: `view-{subject}-{context}`

### 2. Register the CPT
- add a clear CPT registration snippet to `inc/cpt.php`
- keep labels human-readable and slugs machine-stable

### 3. Create the Meta Box schema
- generate the `.mbjson` file with stable field IDs
- keep groups and repeaters explicit rather than burying structure in vague generic fields

### 4. Create the views
- generate single-view Twig and CSS
- generate archive-view Twig and CSS
- keep both aligned to the design system
- use `mb.*` for single context and `post.*` for archive context
- keep local reference copies in files even if the live views are created in admin

### 5. Record the assignment plan
- document whether single and archive output will use MB Views location rules directly or a Blocksy Content Block placement strategy
- update the placement map for both single and archive views

### 6. Validate the artifact set
- confirm the CPT registration, `.mbjson`, views, and placement map agree with each other
- confirm no hardcoded colors or unsupported breakpoints were introduced
- confirm the naming is consistent across PHP, JSON, Twig, CSS, and project context

---

## Output Format

```text
CPT: [slug]
Files created: [count]
Files updated: [count]
Artifacts:
- [path] - [purpose]
- [path] - [purpose]
Assignment plan:
- Single: [decision]
- Archive: [decision]
Taxonomy impact: [none / created / deferred]
Follow-up review: [prompt name or none]
```

Proceed with the new CPT build now.
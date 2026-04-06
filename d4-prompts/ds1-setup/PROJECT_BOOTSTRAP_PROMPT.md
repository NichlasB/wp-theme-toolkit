<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Project Bootstrap Prompt

Use this prompt when starting a new Meta Views Stack site project.

Its job is to turn a plain-language site brief into the first working project artifact set so the project has a stable file-based foundation before view generation begins.

---

## Purpose

Run this when:
- the site project is new
- `_project-context.md` does not exist yet
- the Blocksy child theme scaffold is incomplete
- you need a first-pass token system, schema layout, and placement map

Do not use this prompt for a normal new-chat orientation on an already-bootstrapped project. Use `SESSION_BOOTSTRAP_PROMPT.md` instead.

This is a setup workflow, not a launch workflow.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `d1-setup/STACK_REFERENCE.md`
- `d1-setup/PROJECT_CONTEXT_TEMPLATE.md`
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`
- `d3-guides/BLOCKSY_INTEGRATION_GUIDE.md`
- `d3-guides/WORKFLOW_QUICK_REFERENCE.md`

Treat `STACK_REFERENCE.md` and `PROJECT_CONTEXT_TEMPLATE.md` as the structural source of truth.

---

## Required Inputs

If the user has not already provided them, gather these inputs first:
- business or site type
- primary site goal
- vibe words
- color direction: monochrome, one accent, or full palette
- whether a CPT is needed immediately
- whether the project root already exists
- target path for the site project or child theme

Optional but helpful inputs:
- preferred homepage priority sections
- whether a form page is expected soon
- whether the first build milestone is page-first or CPT-first

---

## Required Outputs

Create or update these artifacts in the target project:

1. `_project-context.md`
2. child theme directories: `inc/`, `mb-json/`, `views/`
3. view subdirectories when practical: `views/sections/`, `views/single/`, `views/archive/`, `views/reference/`
4. `style.css` token block when it does not exist yet
5. `functions.php` child-theme bootstrap when it does not exist yet
6. `inc/cpt.php` placeholder when it does not exist
7. placement map section inside `_project-context.md`

If the user requested an initial content model, also create:
- the first `.mbjson` file
- the first local view reference file under `views/`

---

## Target Handling Rules

### Normal target

The preferred target is the Blocksy child-theme root.

### Nested project target

If the user points at a broader site repository and the child theme is nested inside it:
- keep the child theme as the implementation root
- note the broader repo root in `_project-context.md` only if it matters operationally
- write `_project-context.md` in the child-theme root unless the user explicitly wants a different location

### Incomplete target

If the child theme does not exist yet:
- create the minimum scaffold described in `STACK_REFERENCE.md`
- do not invent extra folders beyond the documented baseline unless the user asked for them

---

## Workflow

### 1. Confirm target root and current state
- confirm whether the target is a child-theme root or a broader site project
- identify which core files already exist
- preserve existing valid files instead of overwriting them blindly
- if `style.css` or `functions.php` already exist, extend them carefully rather than replacing them wholesale

### 2. Create the project context
- use `d1-setup/PROJECT_CONTEXT_TEMPLATE.md` as the schema
- fill in the stack, brand direction, token block, naming conventions, content-model seed, and placement map skeleton
- record any open decisions rather than guessing if the brief is incomplete

### 3. Create the child theme scaffold
- ensure `style.css`, `functions.php`, `inc/cpt.php`, `mb-json/`, and `views/` exist
- create the view subdirectories when useful for immediate work
- keep boilerplate aligned with `d1-setup/STACK_REFERENCE.md`

### 4. Add the first token block
- add the canonical token block to `style.css`
- map the Blocksy palette roles in `_project-context.md`
- do not create a second design-token system in view-level files

### 5. Seed the first build artifact when requested
- if the brief already implies a homepage hero, reusable section, or first CPT, create the first `.mbjson` or local view reference file
- keep the artifact scope narrow and aligned to the immediate next build step

### 6. Validate the bootstrap result
- confirm `_project-context.md` exists and contains the placement map section
- confirm the token block exists in `style.css`
- confirm `functions.php` and `inc/cpt.php` are present when needed
- confirm the next workflow is obvious from the generated artifact set

---

## Constraints

- do not use plugin-specific workflows or language
- do not leave placement decisions undocumented
- do not invent alternate spacing or breakpoint systems
- do not rely on the Meta Box UI as the only source of truth
- do not create placeholder content that conflicts with the actual brief
- do not create deployment or launch files that are out of v1 scope

---

## Output Format

Start with:

```text
Target root: [path]
Project state before bootstrap: [empty / partial / existing child theme]
Files created: [count]
Files updated: [count]
Deferred items: [count]
Initial artifacts:
- [path] - [purpose]
- [path] - [purpose]
Immediate next step: [prompt name]
```

Then report:
- the token direction chosen
- the initial content-model decision
- any deferred questions or unresolved assumptions
- the next recommended prompt

---

## Final Assistant Output

After the work is complete, report:
- the exact target root used
- the exact files created or updated
- any deferred decisions that still need user input
- whether the project is ready for `@DESIGN_TOKENS_PROMPT.md run`, `@NEW_PAGE_PROMPT.md run`, or `@NEW_CPT_PROMPT.md run`

Proceed with project bootstrap now.
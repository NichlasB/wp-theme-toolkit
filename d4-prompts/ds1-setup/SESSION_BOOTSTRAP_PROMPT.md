<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Session Bootstrap & Context Map

Use this prompt at the start of a new chat when you are about to work on an existing Meta Views Stack site project.

Its job is to create a compact, session-specific context map so the assistant can spend less time rediscovering the project structure in later turns.

---

## Purpose

Run this before feature work, new page work, CPT work, design-system review, or pre-launch review when:
- the chat is new
- the project has not been discussed yet in the current thread
- you want a reusable map of the site project before asking for concrete changes

This is an orientation workflow, not an implementation workflow.

If the likely next step will modify files, recommend `RESTORE_POINT_PROMPT.md` before the first edit-heavy workflow unless the user already created a restore point for the session.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `d3-guides/WORKFLOW_QUICK_REFERENCE.md`
- `d1-setup/STACK_REFERENCE.md`
- `d1-setup/PROJECT_CONTEXT_TEMPLATE.md`

Use those files to understand:
- what counts as a normal target
- which files matter most for project orientation
- which prompt families are most likely to be useful next

---

## Required Output File

Create a temporary Markdown file in the target project root using this filename:

```text
session-context.tmp.md
```

If a file with that name already exists, overwrite it.

Do not create this file inside the toolkit itself unless the user explicitly asks you to run the workflow on the toolkit.

Treat this file as temporary local workflow context. It should not be committed.

---

## Atypical Target Fallback

Most uses of this prompt should target a site project or Blocksy child theme, but occasionally the user may explicitly point it at an atypical folder.

If that happens:
- honor the explicit target choice
- infer the best available identity from `style.css`, `_project-context.md`, or folder naming
- mark inferred values clearly in the output
- prioritize operational files and project context over forcing a normal child-theme map

---

## What To Scan

Scan the target project with a bias toward high-value orientation, not exhaustiveness.

Do not dump the full file tree unless the project is tiny. Prefer a trimmed path list or short important-path inventory.

### 1. Project identity
- project or site name
- target root path
- whether the child theme root is the project root or nested inside it
- whether `_project-context.md` exists
- whether the project appears to be a normal Meta Views Stack target or an atypical folder

### 2. Shape and structure
- major top-level folders
- presence of `mb-json/`, `views/`, `inc/cpt.php`, `style.css`, `functions.php`
- whether the project looks complete, partial, or in early bootstrap state
- whether the local reference-copy workflow appears to be in use

### 3. Content-model surfaces
- active CPTs and taxonomies
- `.mbjson` files
- local Twig and CSS reference files
- placement map status
- obvious missing relationships between CPTs, fields, and views

### 4. Design-system surface
- whether the token block exists
- whether the naming rules appear consistent
- whether the project appears aligned with the design system
- whether unsupported breakpoints or raw values appear likely from file naming or quick inspection

### 5. Workflow recommendation
- recommend the most relevant next prompt
- if edits are likely, recommend `RESTORE_POINT_PROMPT.md`

### 6. Risks and unknowns
- identify the few uncertainties most likely to matter in later turns
- flag missing `_project-context.md`, missing placement map, or no local view copies as operational risks

---

## Output File Format

Write the file in this structure:

```text
# SESSION CONTEXT MAP

- Project: [name]
- Date: [YYYY-MM-DD]
- Assessed from: [path]
- Child theme root: [path]
- Project context file: [present / missing]

## 1. Snapshot
- Build state: [bootstrap / active build / review-ready / pre-launch]
- Summary:
  - [short point]
  - [short point]
  - [short point]

## 2. Important Paths
- `[path]` - [why it matters]
- `[path]` - [why it matters]
- `[path]` - [why it matters]

## 3. Content Model
- CPTs: [summary]
- Taxonomies: [summary]
- MB JSON files: [summary]
- Local view files: [summary]
- Placement map: [summary]

## 4. Design System Status
- Token block: [present / missing]
- Placement map: [present / missing / partial]
- Naming consistency: [good / mixed / unclear]
- Responsive rule consistency: [good / mixed / unclear]

## 5. Recommended Next Toolkit Workflows
- `[prompt file]` - [why]
- `[prompt file]` - [why]

## 6. Risks / Unknowns
- [risk]
- [risk]

## 7. Suggested First Follow-Up Prompt
`[one concrete next prompt]`
```

Keep the file concise and scannable.
Aim for something that is genuinely useful as a session reference, not a full audit.

---

## Output Format

After writing the file, summarize the result in chat using this structure:

```text
Target project: [name]
Context file created: [path]
Important paths: [count]
Recommended next workflows: [count]
Most likely next step: [prompt name]
```

Then list the top important paths and the most relevant next workflows.

---

## Final Assistant Output

After writing `session-context.tmp.md`, also report in chat:
- the exact file path created
- the target project identified
- the top 3-5 important paths
- the most relevant next workflows
- whether the normal order should be session bootstrap then restore point, or the strict reverse order

If the likely next step is implementation or other file edits, note the recommended order explicitly.

Proceed with session bootstrap now.
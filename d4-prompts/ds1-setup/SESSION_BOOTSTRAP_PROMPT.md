<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Session Bootstrap & Context Map

This file is a toolkit-specific adapter around the shared bootstrap core.

Shared core source:
- `wp-workflow-toolkit/d4-prompts/ds1-session/SESSION_BOOTSTRAP_CORE_PROMPT.md`

Use this prompt at the start of a new chat when you are about to work on an existing Meta Views Stack site project.

Before applying the site-specific scan and output rules below, read and apply the shared bootstrap core.

---

## Theme-Specific Primary References

Before scanning, read:
- `_TASK_RUNNER.md`
- `d3-guides/WORKFLOW_QUICK_REFERENCE.md`
- `d1-setup/STACK_REFERENCE.md`
- `d1-setup/PROJECT_CONTEXT_TEMPLATE.md`

Use those files to understand:
- what counts as a normal target
- which files matter most for project orientation
- which prompt families are most likely to be useful next

---

## Theme-Specific Target Notes

- The normal target is a Meta Views Stack site project or Blocksy child theme.
- Prefer identity clues from `style.css`, `functions.php`, `_project-context.md`, folder naming, and the presence of `mb-json/`, `views/`, or `inc/cpt.php`.
- If the target is atypical, prioritize operational files and project context over forcing a normal child-theme map.

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

### 3a. Runtime validation note
- if CPT work, archive work, or taxonomy-driven homepage sections appear likely, check whether the expected CPTs are actually visible in wp-admin or otherwise confirmed active at runtime
- if the codebase contains staged or feature-flagged CPT registrations, note the active source of truth and any risk of double registration or disabled admin menus
- if a new CPT was recently enabled, note whether a permalink flush may be required

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
- include missing runtime confirmation for expected CPTs as a risk when relevant

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

## 3a. Runtime Validation
- CPT visibility: [confirmed / unconfirmed / blocked]
- Active registration source: [summary]
- Notes: [brief note]

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
When runtime confirmation is not possible from the current environment, say so explicitly and recommend the smallest manual check needed in wp-admin.

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
- whether the normal order should be session bootstrap, guided execution when useful, then restore point, or the strict reverse order

If the likely next step is implementation or other file edits, note the recommended order explicitly.

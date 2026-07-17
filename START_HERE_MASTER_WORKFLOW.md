<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Start Here Master Workflow

Use this file first when starting, resuming, planning, building, reviewing, deploying, or improving a Meta Views Stack site project.

This is the only workflow file the user should need to remember after a long break. Its job is to classify the situation, gather only the missing context, and route to the exact next toolkit prompt.

---

## Primary References

Before making a recommendation, read only the references needed for the detected mode:

- `_TASK_RUNNER.md`
- `d3-guides/WORKFLOW_QUICK_REFERENCE.md`
- `d1-setup/PROJECT_CONTEXT_TEMPLATE.md`
- `d1-setup/PROJECT_STATUS_TEMPLATE.md`
- `d3-guides/CLAUDE_DESIGN_HANDOFF_WORKFLOW.md` when a visual design, Claude Design project, mockup, screenshot, or HTML export is involved

If the target project already exists, also look for:

- `_project-context.md`
- `mvs-project-status.md`
- `session-context.tmp.md`
- `session-handoff.tmp.md`
- `DEPLOYMENT_CHECKLIST.md`
- `PRE_LAUNCH_CHECKLIST.md`
- Git status for the target project or child theme

---

## Operating Rule

Ask only the minimum useful questions.

- Ask at most 5 questions at a time.
- Prefer safe defaults when the answer can wait.
- Record unknowns as open decisions.
- Always end with one concrete next prompt.
- Do not make the user remember the prompt library.

---

## Context Refresh Rule

Before any major phase transition, long-session continuation, context-compaction recovery, or deployment-risk task, refresh from the smallest useful anchor set before continuing.

Default refresh set:

- `START_HERE_MASTER_WORKFLOW.md`
- `_project-context.md` in the target project when present
- `mvs-project-status.md` in the target project when present
- the next routed prompt

Also read these when relevant:

- `session-context.tmp.md` and `session-handoff.tmp.md` when resuming work
- `d1-setup/LOCALWP_DATABASE_ACCESS_WORKFLOW.md` before LocalWP SQL, migration, import, export, or reconciliation work
- `d3-guides/CLAUDE_DESIGN_HANDOFF_WORKFLOW.md` before Claude Design or visual handoff conversion
- deployment checklists before GridPane launch, post-launch update, or reverse refresh work

Use this rule proactively. The user should not have to ask for a memory refresh when the workflow is changing phases or the chat has become long.

---

## Project Phase Model

Classify every project or session into one current phase:

```text
0. Intake
1. Design direction
2. Design handoff
3. Bootstrap
4. Token setup
5. Content model
6. Page build
7. Refinement
8. QA
9. Deploy
10. Maintenance
```

Use the phase to explain where the project is and what comes next.

---

## Client Editability Levels

Record one editability level for every project:

```text
Managed
Agency controls layout/templates. Client edits content entries, forms, and approved fields only.

Guided
Client edits fields plus limited Gutenberg or pattern-based areas. Layout authority stays with MVS.

Flexible
Client can edit broader Gutenberg content areas. MVS still controls global styling and reusable systems.

Builder
Project intentionally uses a page builder outside the normal MVS workflow.
```

If the user says the client can edit "a bit", default to `Guided` unless the project clearly needs `Managed` or `Flexible`.

---

## Session Modes

### Mode A: New Site Intake

Use when:
- the project is new
- the user has a vague idea but no project context
- the target project does not yet have `_project-context.md`

Gather:
- business/site type
- audience
- primary goal
- required pages
- brand direction
- design source
- client editability level
- expected forms, SEO, analytics, deployment, and maintenance needs

Output:
- recommended phase: `Intake`
- open decisions
- whether Claude Design should be used
- next prompt: `@PROJECT_BOOTSTRAP_PROMPT.md run`

If Claude Design should come first, generate a Claude Design starter prompt and route to the handoff guide before bootstrap.

### Mode B: Claude Design / Mockup Handoff

Use when:
- the user has a Claude Design project
- the user has a screenshot, mockup, HTML export, handoff bundle, or design brief
- the project needs design-to-MVS conversion

Read:
- `d3-guides/CLAUDE_DESIGN_HANDOFF_WORKFLOW.md`

Output:
- design source
- handoff quality
- extracted section inventory
- likely token implications
- likely editable zones
- next prompt: `@DESIGN_HANDOFF_TO_MVS_PROMPT.md run`

### Mode C: Existing Project Resume

Use when:
- the user returns after a break
- the project already exists
- the current state is unclear

Scan:
- `_project-context.md`
- `mvs-project-status.md`
- `session-context.tmp.md`
- `session-handoff.tmp.md`
- important child-theme paths
- Git status

Output:
- current phase
- last known workflow
- next recommended workflow
- open decisions and blockers
- next prompt: usually `@SESSION_BOOTSTRAP_PROMPT.md run`

If edits are likely, recommend `@RESTORE_POINT_PROMPT.md run` after session bootstrap.

### Mode D: Build Next Page / Section / CPT

Use when:
- the user wants to build a page, section, or content type
- the project context is already clear

Route:
- unclear page shape -> `@PAGE_SCOPING_CHECKLIST_PROMPT.md run`
- normal page -> `@NEW_PAGE_PROMPT.md run`
- structured content type -> `@NEW_CPT_PROMPT.md run`
- token change first -> `@DESIGN_TOKENS_PROMPT.md run`

### Mode E: Review / QA / Pre-Launch

Use when:
- the site or page exists and needs inspection
- the user asks for review, QA, responsive checks, accessibility, SEO, performance, or final launch checks

Route:
- view/template review -> `@VIEW_REVIEW_PROMPT.md run`
- multi-view CSS audit -> `@CSS_CONSISTENCY_AUDIT_PROMPT.md run`
- design-system compliance -> `@DESIGN_SYSTEM_COMPLIANCE_PROMPT.md run`
- pre-launch sequence -> run prompts `01` through `05`, then `@05A-SECURITY_REVIEW_PROMPT.md run`, then `@06-FINAL_CHECKLIST_PROMPT.md run` last
- confirmed WordPress runtime behavior needs testing or troubleshooting -> `C:\Users\Captain\Documents\AI Workflows\Task Workflows\WordPress\wordpress-component-testing-troubleshooting-debugging-workflow.md`

Use the standalone component workflow only when real WordPress behavior, environment state, or a reproducible defect needs runtime evidence. Do not require a ceremonial full runtime pass for static presentation-only work; record the not-applicable rationale and continue with the relevant source, visual, and pre-launch checks.

### Mode F: Deploy / Post-Launch / Reverse Refresh

Use when:
- moving LocalWP to GridPane
- doing post-launch updates
- refreshing local from production or staging

Route:
- first launch -> `@GRIDPANE_DEPLOYMENT_PROMPT.md run`
- incremental update -> `@POST_LAUNCH_GRIDPANE_UPDATE_PROMPT.md run`
- pull GridPane content back to LocalWP -> `@LOCALWP_REVERSE_REFRESH_PROMPT.md run`

### Mode G: Toolkit Improvement

Use only when:
- the user wants to improve `wp-theme-toolkit`
- a real workflow lesson should become reusable toolkit guidance

Route:
- `@TOOLKIT_LESSONS_AUDIT_PROMPT.md run`

Do not use this mode for normal project-specific styling, content, or deployment issues.

---

## Required Output

Return this concise router summary:

```text
Detected mode: [A-G]
Current phase: [phase number and name]
Target project: [path or unknown]
Status snapshot: [present / missing / needs update]
Design source: [none / Claude Design / mockup / HTML export / existing site / unknown]
Client editability: [Managed / Guided / Flexible / Builder / undecided]
Open decisions:
- [decision or none]
Recommended next prompt:
`@[prompt filename] run`
Why this prompt:
- [short reason]
```

If the next step needs user input, ask only the minimum questions and then stop.

If the next step is obvious, name it clearly and stop.

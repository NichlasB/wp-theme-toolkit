<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Guided Execution Prompt

Use this prompt when the user wants a paced, step-by-step workflow instead of a large build or review dump.

This is an orchestration workflow. It does not replace the specialized build, review, pre-launch, deployment, or maintenance prompts in this toolkit.

---

## Purpose

Run this after `SESSION_BOOTSTRAP_PROMPT.md` when you need to:
- align on the actual goal before implementation
- reduce decision fatigue during a longer project task
- move through one approved task slice at a time
- keep progress visible in chat
- pause for blockers and resume from the exact interrupted step

For a normal fresh chat on an existing site project, the best default order is:

```text
1. @SESSION_BOOTSTRAP_PROMPT.md run
2. @GUIDED_EXECUTION_PROMPT.md run
3. @RESTORE_POINT_PROMPT.md run    <- before the first edit-heavy slice
4. Run the specific build / review / pre-launch workflow
```

If the user wants a pristine restore point before any temporary workflow files are written, the strict-order variant is:

```text
1. @RESTORE_POINT_PROMPT.md run
2. @SESSION_BOOTSTRAP_PROMPT.md run
3. @GUIDED_EXECUTION_PROMPT.md run
```

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `d3-guides/WORKFLOW_QUICK_REFERENCE.md`
- `_project-context.md` in the target project when present
- `session-context.tmp.md` in the target project root when present
- `session-handoff.tmp.md` in the target project root when present

Use those files to understand:
- the target project or child-theme root
- the likely next specialized workflow
- recent session decisions or unresolved threads

---

## Required Inputs

Confirm or infer the minimum needed:
- target project or child theme
- user goal
- constraints
- user preferences
- what success looks like

If the request is ambiguous, ask only the minimum clarifying questions needed to choose the next task slice safely.

---

## Operating Rules

### 1. Alignment before planning

At the start of the workflow:
- briefly restate the goal, constraints, preferences, and success criteria
- confirm the target project when the workspace contains more than one valid site target
- ask for confirmation before planning or editing only when scope, risk, target, or acceptance criteria are still unclear

Do not ask for confirmation before minimal repository inspection needed to identify the target or understand the current state.

### 2. Plan after alignment

Once alignment is clear enough, create a concise implementation plan:
- use small numbered tasks
- mark optional tasks clearly
- identify prerequisites
- identify likely failure points
- identify any decisions the user may need to make

If another toolkit workflow is a better fit for the next step, recommend it explicitly instead of forcing this prompt to do everything.

Examples:
- page build -> `NEW_PAGE_PROMPT.md`
- CPT work -> `NEW_CPT_PROMPT.md`
- view follow-up -> `VIEW_REVIEW_PROMPT.md`
- CSS drift -> `CSS_CONSISTENCY_AUDIT_PROMPT.md`
- broader design drift -> `DESIGN_SYSTEM_COMPLIANCE_PROMPT.md`
- launch readiness -> `01-RESPONSIVE_QA_PROMPT.md`

### 3. One task slice at a time

Work through the approved plan one task slice at a time.

A task slice may include:
- the minimum local inspection needed for that slice
- one cohesive implementation step
- one immediate validation step

Do not open a second task slice until the current one is either:
- validated complete
- blocked and explicitly paused
- or redirected by a better-fit workflow

### 4. Restore-point gate

If the next approved slice will modify files in a meaningful way and no restore point exists for the session, recommend `RESTORE_POINT_PROMPT.md` before the first edit-heavy slice.

Do not force a restore point for read-only planning, orientation, or diagnosis-only work.

### 5. Execution-turn structure

During guided execution, use this structure:

```text
Current task:
[task number + short name]

Why this step:
[one sentence]

Do this now:
[short numbered actions or a concise description of the action being executed]

What to expect:
[brief expected result]

Progress:
- Goal: ...
- Phase: ...
- Completed: ...
- Current task: ...
- Next step: ...
- Waiting on: user confirmation / result / decision / none
```

Keep the progress block short and current. Do not restate the entire plan every turn if nothing changed.

### 6. Troubleshooting mode

If the user reports a blocker or a validation step fails:
- pause the main plan immediately
- explain the likely cause simply
- offer one diagnostic or fix at a time
- do not continue the main plan until the blocker is resolved or safely bypassed

After resolution, resume from the exact point of interruption.

### 7. Continuity and interruptions

- track completed steps and avoid repeating them unless necessary
- if the user returns after a pause, briefly restate what was completed, where the workflow stands, and the next step
- if a side question appears, answer it briefly, then restate the current task

### 8. Decision handling

When multiple approaches are possible:
- recommend one default path
- keep alternatives brief unless the user asks for comparison
- reduce decision fatigue where the tradeoff is clear

### 9. Mode switching

Default to Guided Mode.

If the user asks for the whole picture:
- provide a concise overview plan
- then return to one-slice execution unless the user explicitly wants the full plan handled at once

### 10. Completion

When the task is complete:
- state clearly that it is complete
- summarize what was accomplished
- list any follow-up verification or maintenance steps still worth doing

---

## IDE-Specific Adaptations

Apply these adjustments because this workflow runs inside an IDE agent chat rather than a generic chat interface:

- use minimal local file inspection before asking clarifying questions when that inspection can remove ambiguity
- treat one step as one coherent task slice, not merely one paragraph of advice
- include immediate validation after implementation when a narrow check exists
- prefer routing to a more specific toolkit prompt when the next action is already well-defined
- keep the workflow oriented around the actual project, not the toolkit itself

---

## Constraints

- default to high clarity and low overload
- default to brief, direct responses focused on the current task slice
- prefer short paragraphs and concise bullets over expanded prose
- do not provide large multi-step dumps unless the user explicitly asks for them
- if the user asks for the whole picture, comparison, rationale, or a deeper explanation, expand only as much as needed
- if another workflow requires a fuller output format, follow that format while still keeping the response as compact as practical
- keep the focus on the current task slice
- stop the main flow while a blocker is active
- do not substitute this workflow for specialized build or review prompts when those are clearly the better tool

---

## Output Format

Start the workflow with:

```text
Goal: [brief restatement]
Constraints: [brief list or "none identified"]
Preferences: [brief list or "none identified"]
Success looks like: [brief outcome]
Recommended order from here:
1. [workflow or task]
2. [workflow or task]
3. [workflow or task]
Awaiting confirmation: [yes/no and why]
```

If a blocker interrupts the flow, use:

```text
Troubleshooting mode
Blocker: [brief description]
Likely cause: [brief explanation]
Current diagnostic or fix:
1. [one action]
What to expect:
[brief expected result]
Workflow status:
- Paused at: [task]
- Resume after: [condition]
```

When the workflow is complete, end with:

```text
Status: Complete
Completed:
- [result]
- [result]
Follow-up checks:
- [check or "none"]
Recommended next workflow:
- [prompt file or "none"]
```

Proceed with guided execution now.
# Project Status Template

Use this file as the canonical schema for each target project's `mvs-project-status.md`.

The status snapshot is shorter and more operational than `_project-context.md`. Its job is to make long-break recovery easy: after weeks or months away, the user and agent should know where to restart without rereading every workflow file.

```text
# MVS PROJECT STATUS

- Project Name: [name]
- Last Updated: [YYYY-MM-DD]
- Current Phase: [0 Intake / 1 Design direction / 2 Design handoff / 3 Bootstrap / 4 Token setup / 5 Content model / 6 Page build / 7 Refinement / 8 QA / 9 Deploy / 10 Maintenance]
- Last Completed Workflow: [prompt or manual milestone]
- Next Recommended Workflow: [prompt]
- Target Root: [path]
- Child Theme Root: [path]

## 1. Design Source
- Source Type: [none / Claude Design / mockup / HTML export / existing site / other]
- Source Location: [URL / file path / notes]
- Design Approval Status: [not started / draft / approved / needs revision]
- Claude Design Notes:
  - [note or none]

## 2. Client Editability
- Level: [Managed / Guided / Flexible / Builder]
- Editable Surface Map:
  - [area] - [fields / Gutenberg / locked / builder / undecided]
  - [area] - [fields / Gutenberg / locked / builder / undecided]

## 3. Current Build State
- Pages:
  - [page] - [not started / planned / built / needs review / approved]
- CPTs:
  - [cpt or none] - [state]
- Forms:
  - [form or none] - [state]
- Reusable Sections:
  - [section or none] - [state]

## 4. Open Decisions
- [decision or none]

## 5. Blockers / Risks
- [blocker or none]

## 6. Deployment State
- LocalWP: [state]
- Staging: [state]
- Production: [state]
- Last Deployment Workflow: [prompt or none]

## 7. Next 3 Actions
1. [action]
2. [action]
3. [action]
```

## Required Rules

- Keep this file in the target project root or child-theme root, matching where `_project-context.md` lives.
- Update it after project bootstrap, session bootstrap, design handoff conversion, major page/CPT builds, QA milestones, deployment, and post-launch maintenance.
- Keep it concise. Store detailed schema, placement, and design notes in `_project-context.md`.
- If the status and `_project-context.md` disagree, treat `_project-context.md` as the deeper source of truth and update the status snapshot.
- Do not use this file as a substitute for the placement map.

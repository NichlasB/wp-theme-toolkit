# Task Runner Instructions

This file provides execution context for AI assistants running tasks from this toolkit. Read this file first when any task from `wp-theme-toolkit/d4-prompts/` is referenced.

---

## Overview

This toolkit contains build, review, launch-readiness, and deployment tasks for WordPress site projects built with the Meta Views Stack.

Important: the `wp-theme-toolkit/` folder is normally not the target of these tasks. It contains the instructions, not the site code.

Exception: `d4-prompts/ds6-git/GIT_OPERATIONS_PROMPT.md` may target either `wp-theme-toolkit/` itself or a child-theme/site repository in the same workspace.

---

## Command Syntax

When a user references a task file, they may use these commands:

| Command | Meaning |
|---------|---------|
| `@filename run` | Execute the task. |
| `@filename run all` | Execute the full task without pausing for confirmation. |

If the user's instruction is ambiguous, ask for clarification.

---

## Target Selection

### Identifying Meta Views Stack Site Projects

A target site project or child theme is usually identified by one or more of these indicators:

1. `style.css` in the target theme root with a `Theme Name:` header
2. `functions.php` in the same root
3. `_project-context.md` in the root or child-theme folder
4. `mb-json/` for Meta Box configuration files
5. `views/` for local reference copies of MB Views
6. `inc/cpt.php` or equivalent registration files

### Before Starting Any Task

For site-facing prompts, use the rules below.

For `GIT_OPERATIONS_PROMPT.md`, the valid target may be either `wp-theme-toolkit/` itself or a site/child-theme repository.

1. Scan the workspace for likely site targets, excluding `wp-theme-toolkit/`.
2. If one likely target exists, proceed with it and confirm to the user.
3. If multiple likely targets exist, ask which one to use.
4. If no likely target exists, ask the user to confirm the folder that should become the project root.

The preferred target root is the Blocksy child-theme root or the site project root that contains the child theme.

---

## Task Types

All tasks in v0.1.0 are single-phase tasks.

They may still create files, update files, or produce temporary context artifacts, but they do not use a formal phase boundary.

### Tasks in this category

- PROJECT_BOOTSTRAP_PROMPT.md
- SESSION_BOOTSTRAP_PROMPT.md
- RESTORE_POINT_PROMPT.md
- DESIGN_TOKENS_PROMPT.md
- NEW_PAGE_PROMPT.md
- NEW_CPT_PROMPT.md
- VIEW_REVIEW_PROMPT.md
- CSS_CONSISTENCY_AUDIT_PROMPT.md
- DESIGN_SYSTEM_COMPLIANCE_PROMPT.md
- 01-RESPONSIVE_QA_PROMPT.md
- 02-ACCESSIBILITY_REVIEW_PROMPT.md
- 03-SEO_REVIEW_PROMPT.md
- 04-PERFORMANCE_REVIEW_PROMPT.md
- 05-CROSS_BROWSER_QA_PROMPT.md
- 06-FINAL_CHECKLIST_PROMPT.md
- GRIDPANE_DEPLOYMENT_PROMPT.md
- GIT_OPERATIONS_PROMPT.md

---

## Output Expectations

### During Execution

- Report progress while working through the task checklist
- When a task creates or updates files, report the exact file paths created or changed in the target project
- Keep summaries aligned with the task's declared output format

### On Completion

- Provide a summary that matches the prompt's output format
- If the prompt requires a temporary context file, report the exact temporary file path created in the target project
- If the prompt finds issues that should trigger another workflow, recommend the next prompt clearly

### Checklist Registration

After a supported workflow completes successfully for a target project, update `PRE_LAUNCH_CHECKLIST.md` in this toolkit during the same turn.

Rules:
- Treat `PRE_LAUNCH_CHECKLIST.md` as the canonical tracking file for completed workflows
- If the target project does not yet have an entry, create one from the template before finishing
- Update only the row that matches the completed workflow
- Preserve older completion dates unless the user explicitly wants to overwrite them
- If a task is blocked, do not mark it complete

Prompt-to-checklist mapping:
- `PROJECT_BOOTSTRAP_PROMPT.md` -> `Setup & Build` -> `Project Bootstrap`
- `SESSION_BOOTSTRAP_PROMPT.md` -> `Setup & Build` -> `Session Bootstrap`
- `DESIGN_TOKENS_PROMPT.md` -> `Setup & Build` -> `Design Tokens`
- `NEW_PAGE_PROMPT.md` -> `Setup & Build` -> `New Page Build`
- `NEW_CPT_PROMPT.md` -> `Setup & Build` -> `New CPT Build`
- `VIEW_REVIEW_PROMPT.md` -> `Review Workflows` -> `View Review`
- `CSS_CONSISTENCY_AUDIT_PROMPT.md` -> `Review Workflows` -> `CSS Consistency Audit`
- `DESIGN_SYSTEM_COMPLIANCE_PROMPT.md` -> `Review Workflows` -> `Design System Compliance Audit`
- `01-RESPONSIVE_QA_PROMPT.md` -> `Pre-Launch Reviews` -> `01 Responsive QA`
- `02-ACCESSIBILITY_REVIEW_PROMPT.md` -> `Pre-Launch Reviews` -> `02 Accessibility Review`
- `03-SEO_REVIEW_PROMPT.md` -> `Pre-Launch Reviews` -> `03 SEO Review`
- `04-PERFORMANCE_REVIEW_PROMPT.md` -> `Pre-Launch Reviews` -> `04 Performance Review`
- `05-CROSS_BROWSER_QA_PROMPT.md` -> `Pre-Launch Reviews` -> `05 Cross-Browser QA`
- `06-FINAL_CHECKLIST_PROMPT.md` -> `Pre-Launch Reviews` -> `06 Final Checklist`

Deployment workflows:
- `GRIDPANE_DEPLOYMENT_PROMPT.md` updates `DEPLOYMENT_CHECKLIST.md`, not `PRE_LAUNCH_CHECKLIST.md`

---

## File Modification Rules

- Setup and build tasks may create or update files in the target project
- Review and pre-launch tasks may update low-risk issues when the prompt explicitly allows it
- Restore operations must never run without explicit approval after a preview
- Keep local reference copies of Twig and CSS in files whenever live MB View content is changed in the WordPress admin

---

## Error Handling

- Task file not found: tell the user and list available tasks in `d4-prompts/`
- Ambiguous target: ask the user which site project or child theme to use
- Missing `_project-context.md`: recommend `PROJECT_BOOTSTRAP_PROMPT.md` or ask to create the file from the template
- Missing placement map: create or repair it before continuing with template-assignment work

---

## Quick Reference

```text
wp-theme-toolkit/   <- normally not the target
├── d1-setup/       <- setup references and project schema
├── d2-scripts/     <- restore-point helpers
├── d3-guides/      <- design, Twig, Blocksy, workflow, and model guides
├── d4-prompts/
│   ├── ds1-setup/      <- project bootstrap, session bootstrap, restore point
│   ├── ds2-build/      <- page, CPT, and token generation
│   ├── ds3-review/     <- view and CSS audits
│   ├── ds4-pre-launch/ <- launch-readiness sequence
│   ├── ds5-deploy/     <- deployment workflow prompts
│   └── ds6-git/        <- git operations and release workflow prompt
└── other-folders/  <- target site projects or child themes
```
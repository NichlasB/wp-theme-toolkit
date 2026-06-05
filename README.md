# WP Theme Toolkit

A structured toolkit of prompts, guides, and safety workflows for AI-assisted WordPress site building with the Meta Views Stack.

## What This Is

This toolkit is the site-building parallel to `wp-plugin-toolkit`.

It is built for a code-first workflow that uses:
- LocalWP for local WordPress development
- Blocksy Pro as the parent theme
- a Blocksy child theme as the editable code surface
- Meta Box AIO for CPTs, fields, groups, and MB Views
- MB Views for Twig, HTML, and CSS rendering
- VS Code, GitHub Copilot, Codex, Cursor, or Windsurf for implementation
- Element to LLM for live DOM and style capture during refinement

The goal: build launch-ready WordPress sites with a repeatable AI workflow, while keeping templates, field definitions, CSS rules, and project context legible in files and tracked in Git.

## What This Toolkit Enforces

- a shared design-token system for spacing, typography, width, and color usage
- consistent Twig patterns for Meta Box fields and archive loops
- a clear boundary between MB Views template logic and Blocksy Content Block placement
- reusable session bootstrap, session handoff, and restore-point workflows
- a local session-bootstrap adapter plus compatibility wrappers for shared workflow prompts sourced from `wp-workflow-toolkit`, while keeping local `@filename` usage unchanged

Shared workflow note: `SESSION_BOOTSTRAP_PROMPT.md` now combines theme-specific scan/output rules with the shared bootstrap core in `wp-workflow-toolkit`. `GUIDED_EXECUTION_PROMPT.md`, `SESSION_HANDOFF_PROMPT.md`, `RESTORE_POINT_PROMPT.md`, and `TOOLKIT_LESSONS_AUDIT_PROMPT.md` remain local prompt names but are thin wrappers around canonical shared sources there.

Shared workflow boundary:
- a prompt belongs in `wp-workflow-toolkit` only when the workflow intent, execution contract, and safety assumptions stay materially the same across both toolkits
- a prompt stays local when theme-specific targets, scan surfaces, release rules, or output formats would otherwise dominate the file
- update the shared canonical source first; update the local theme wrapper or adapter only when the theme-specific supplement changes
- ordered review and pre-launch quality gates before a site goes live
- a documented GridPane deployment flow and Git timing guidance for the child theme lifecycle
- a LocalWP reverse refresh workflow for pulling GridPane database content and missing uploads back to local safely
- a Git operations workflow for committing, pushing, and releasing either the toolkit repo or a target child-theme repo
- a toolkit lessons audit workflow for turning real chat lessons into approval-gated toolkit improvements

## Quick Start

When you are not sure where to begin, start here:

```text
@START_HERE_MASTER_WORKFLOW.md run
```

The master workflow classifies the session, checks project status, asks only the missing context questions, and routes to the exact next prompt.

### 1. Add The Toolkit Beside Your Site Project

Add this repository and your target site project to the same IDE workspace.

### 2. Starting A New Site Project

1. Run `@START_HERE_MASTER_WORKFLOW.md run`
2. Follow the recommended route into project intake, Claude Design handoff, project bootstrap, token setup, page/CPT build, review, deployment, or maintenance
3. Continue with `@DESIGN_TOKENS_PROMPT.md run`, `@DESIGN_HANDOFF_TO_MVS_PROMPT.md run`, `@PAGE_SCOPING_CHECKLIST_PROMPT.md run`, `@NEW_PAGE_PROMPT.md run`, or `@NEW_CPT_PROMPT.md run`
4. Run the review prompts and the pre-launch sequence `@01-RESPONSIVE_QA_PROMPT.md run` through `@06-FINAL_CHECKLIST_PROMPT.md run`
5. Run `@GRIDPANE_DEPLOYMENT_PROMPT.md run`
6. Run `@LOCALWP_REVERSE_REFRESH_PROMPT.md run` after launch when LocalWP needs fresh GridPane content or missing uploads
7. Run `@GIT_OPERATIONS_PROMPT.md run` when you want assisted commit, push, or release help for either the toolkit repo or the child theme repo

### 3. Starting A New Chat On An Existing Site

1. Run `@START_HERE_MASTER_WORKFLOW.md run`
2. If the master workflow detects an existing project resume, follow its route into `@SESSION_BOOTSTRAP_PROMPT.md run`
3. Read `d1-setup/LOCALWP_DATABASE_ACCESS_WORKFLOW.md` before any LocalWP SQL or migration work
4. Run `@GUIDED_EXECUTION_PROMPT.md run` when you want slower pacing, explicit progress tracking, or one approved task slice at a time
5. Run `@RESTORE_POINT_PROMPT.md run`
6. Review `mvs-project-status.md`, `session-context.tmp.md`, and `session-handoff.tmp.md` when present in the target root
7. Continue with build, review, or pre-launch prompts

When you want to pause and continue the same work in a fresh chat, run `@SESSION_HANDOFF_PROMPT.md run` before switching.

Use `@TOOLKIT_LESSONS_AUDIT_PROMPT.md run` only for reusable toolkit lessons, not for one-off site issues or normal project follow-up.

### 4. Pre-Launch Review Order

Run these prompts in order before launch:

1. `@01-RESPONSIVE_QA_PROMPT.md run`
2. `@02-ACCESSIBILITY_REVIEW_PROMPT.md run`
3. `@03-SEO_REVIEW_PROMPT.md run`
4. `@04-PERFORMANCE_REVIEW_PROMPT.md run`
5. `@05-CROSS_BROWSER_QA_PROMPT.md run`
6. `@06-FINAL_CHECKLIST_PROMPT.md run`

## Repository Structure

```text
wp-theme-toolkit/
|
|-- CHANGELOG.md
|-- DEPLOYMENT_CHECKLIST.md
|-- LICENSE
|-- PRE_LAUNCH_CHECKLIST.md
|-- PROJECT_CONTEXT_REFERENCE.txt
|-- README.md
|-- START_HERE_MASTER_WORKFLOW.md
|-- TOOLKIT_QA_REFERENCE.md
|-- _TASK_RUNNER.md
|-- readme.txt
|
|-- d1-setup/
|   |-- 00_REFERENCE_SYSTEM_PROMPTS_FILES_STRUCTURE.txt
|   |-- IDE_SETUP_GUIDE.md
|   |-- LOCALWP_DATABASE_ACCESS_WORKFLOW.md
|   |-- LOCALWP_BLUEPRINT_SETUP.md
|   |-- PROJECT_CONTEXT_TEMPLATE.md
|   |-- PROJECT_STATUS_TEMPLATE.md
|   `-- STACK_REFERENCE.md
|
|-- d2-scripts/
|   |-- restore-point.ps1
|   `-- restore-point.sh
|
|-- d3-guides/
|   |-- BLOCKSY_INTEGRATION_GUIDE.md
|   |-- CLAUDE_DESIGN_HANDOFF_WORKFLOW.md
|   |-- DESIGN_SYSTEM_GUIDE.md
|   |-- ELEMENT_TO_LLM_WORKFLOW.md
|   |-- GIT_WORKFLOW_GUIDE.md
|   |-- IMAGE_ASSET_WORKFLOW.md
|   |-- MODEL_DELEGATION_GUIDE.txt
|   |-- PAGE_DECISION_TREE_CHEAT_SHEET.md
|   |-- PAGE_BUILDING_WORKFLOW.md
|   |-- TWIG_PATTERNS_GUIDE.md
|   `-- WORKFLOW_QUICK_REFERENCE.md
|
|-- d4-prompts/
|   |-- ds1-setup/
|   |   |-- PROJECT_BOOTSTRAP_PROMPT.md
|   |   |-- GUIDED_EXECUTION_PROMPT.md
|   |   |-- RESTORE_POINT_PROMPT.md
|   |   |-- SESSION_HANDOFF_PROMPT.md
|   |   `-- SESSION_BOOTSTRAP_PROMPT.md
|   |
|   |-- ds2-build/
|   |   |-- DESIGN_HANDOFF_TO_MVS_PROMPT.md
|   |   |-- DESIGN_TOKENS_PROMPT.md
|   |   |-- NEW_CPT_PROMPT.md
|   |   |-- PAGE_SCOPING_CHECKLIST_PROMPT.md
|   |   `-- NEW_PAGE_PROMPT.md
|   |
|   |-- ds3-review/
|   |   |-- CSS_CONSISTENCY_AUDIT_PROMPT.md
|   |   |-- DESIGN_SYSTEM_COMPLIANCE_PROMPT.md
|   |   `-- VIEW_REVIEW_PROMPT.md
|   |
|   |-- ds4-pre-launch/
|   |   |-- 01-RESPONSIVE_QA_PROMPT.md
|   |   |-- 02-ACCESSIBILITY_REVIEW_PROMPT.md
|   |   |-- 03-SEO_REVIEW_PROMPT.md
|   |   |-- 04-PERFORMANCE_REVIEW_PROMPT.md
|   |   |-- 05-CROSS_BROWSER_QA_PROMPT.md
|   |   `-- 06-FINAL_CHECKLIST_PROMPT.md
|   |
|   |-- ds5-deploy/
|   |   |-- GRIDPANE_DEPLOYMENT_PROMPT.md
|   |   |-- LOCALWP_REVERSE_REFRESH_PROMPT.md
|   |   `-- POST_LAUNCH_GRIDPANE_UPDATE_PROMPT.md
|   |
|   |-- ds6-git/
|   |   `-- GIT_OPERATIONS_PROMPT.md
|   |
|   `-- ds7-maintenance/
|       `-- TOOLKIT_LESSONS_AUDIT_PROMPT.md
|
`-- d5-examples/
    |-- example-landing-page-build.md
    |-- example-project-context.md
    `-- example-start-here-master-workflow.md
```

## Core Workflow

1. Start with `START_HERE_MASTER_WORKFLOW.md` when the next workflow is not obvious
2. Plan the project in `_project-context.md` and track restart state in `mvs-project-status.md`
3. Convert Claude Design, mockups, screenshots, or HTML exports into MVS decisions when a visual handoff exists
4. Generate or update tokens and schema artifacts in the child theme
5. Generate MB Views Twig and CSS from the field model
6. Record placement decisions in the assignment map
7. Refine the live result with Element to LLM
8. Run review prompts before launch
9. Deploy the first launch with the GridPane workflow and track rollout in `DEPLOYMENT_CHECKLIST.md`
10. Use the post-launch GridPane update workflow for smaller follow-up staging or production pushes after launch
11. Use the LocalWP reverse refresh workflow when local needs current GridPane database content or missing uploads
12. Use the Git operations prompt when you want assisted commit, push, tag, or release work for the toolkit repo or a child-theme repo

## V1 Scope

Included in v1:
- Start Here master workflow routing for new, stale, visual handoff, build, QA, deployment, and toolkit-improvement sessions
- Claude Design and visual handoff planning support
- Blocksy child theme workflows
- Meta Box AIO and MB Views usage
- project bootstrap, project status snapshots, session bootstrap, and session handoff
- design tokens, page creation, CPT creation, view reviews, and pre-launch QA
- restore-point safety workflow
- deployment checklist and GridPane deployment workflow
- post-launch GridPane update workflow for incremental code, uploads, and selected DB-content pushes
- LocalWP reverse refresh workflow for production or staging database pulls and additive uploads sync back to local
- Git workflow guidance for scaffold timing and code updates
- Git operations prompt for toolkit and child-theme repositories
- toolkit lessons audit workflow for approval-gated maintenance of the toolkit itself

Deferred from v1:
- generic WordPress theme-authoring guidance outside the Meta Views Stack
- theme.json strategy
- WP.org theme-review compliance workflows
- broader maintenance audit families beyond the toolkit lessons retrospective

## Using With AI IDEs

Reference prompts directly in chat:

```text
@START_HERE_MASTER_WORKFLOW.md run
```

```text
@SESSION_BOOTSTRAP_PROMPT.md run
```

```text
@GUIDED_EXECUTION_PROMPT.md run
```

```text
@SESSION_HANDOFF_PROMPT.md run
```

```text
@PAGE_SCOPING_CHECKLIST_PROMPT.md run
```

```text
@DESIGN_HANDOFF_TO_MVS_PROMPT.md run
```

```text
@NEW_PAGE_PROMPT.md run
```

```text
@VIEW_REVIEW_PROMPT.md run
```

```text
@GRIDPANE_DEPLOYMENT_PROMPT.md run
```

```text
@LOCALWP_REVERSE_REFRESH_PROMPT.md run
```

```text
@GIT_OPERATIONS_PROMPT.md run
```

```text
@TOOLKIT_LESSONS_AUDIT_PROMPT.md run
```

Do not use `@TOOLKIT_LESSONS_AUDIT_PROMPT.md run` for project-specific styling, content-entry, or deployment issues unless they exposed a reusable toolkit gap.

See `d1-setup/IDE_SETUP_GUIDE.md` and `d3-guides/WORKFLOW_QUICK_REFERENCE.md` for the operating sequence.

For LocalWP database inspection, reconciliation, and migration work, read `d1-setup/LOCALWP_DATABASE_ACCESS_WORKFLOW.md` first so the chat uses LocalWP's bundled `mysql.exe` instead of trying `wp-load.php` or generic PHP MySQL access.

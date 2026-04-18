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
- ordered review and pre-launch quality gates before a site goes live
- a documented GridPane deployment flow and Git timing guidance for the child theme lifecycle
- a Git operations workflow for committing, pushing, and releasing either the toolkit repo or a target child-theme repo

## Quick Start

### 1. Add The Toolkit Beside Your Site Project

Add this repository and your target site project to the same IDE workspace.

### 2. Starting A New Site Project

1. Read `d1-setup/STACK_REFERENCE.md`, `d1-setup/LOCALWP_BLUEPRINT_SETUP.md`, `d3-guides/DESIGN_SYSTEM_GUIDE.md`, and `d1-setup/PROJECT_CONTEXT_TEMPLATE.md`
2. Run `@PROJECT_BOOTSTRAP_PROMPT.md run`
3. Continue with `@DESIGN_TOKENS_PROMPT.md run`, `@NEW_PAGE_PROMPT.md run`, or `@NEW_CPT_PROMPT.md run`
4. Run the review prompts and the pre-launch sequence `@01-RESPONSIVE_QA_PROMPT.md run` through `@06-FINAL_CHECKLIST_PROMPT.md run`
5. Run `@GRIDPANE_DEPLOYMENT_PROMPT.md run`
6. Run `@GIT_OPERATIONS_PROMPT.md run` when you want assisted commit, push, or release help for either the toolkit repo or the child theme repo

### 3. Starting A New Chat On An Existing Site

1. Run `@SESSION_BOOTSTRAP_PROMPT.md run`
2. Run `@RESTORE_POINT_PROMPT.md run`
3. Review `session-context.tmp.md` and `session-handoff.tmp.md` when present in the target root
4. Continue with build, review, or pre-launch prompts

When you want to pause and continue the same work in a fresh chat, run `@SESSION_HANDOFF_PROMPT.md run` before switching.

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
|-- TOOLKIT_QA_REFERENCE.md
|-- _TASK_RUNNER.md
|-- readme.txt
|
|-- d1-setup/
|   |-- 00_REFERENCE_SYSTEM_PROMPTS_FILES_STRUCTURE.txt
|   |-- IDE_SETUP_GUIDE.md
|   |-- LOCALWP_BLUEPRINT_SETUP.md
|   |-- PROJECT_CONTEXT_TEMPLATE.md
|   `-- STACK_REFERENCE.md
|
|-- d2-scripts/
|   |-- restore-point.ps1
|   `-- restore-point.sh
|
|-- d3-guides/
|   |-- BLOCKSY_INTEGRATION_GUIDE.md
|   |-- DESIGN_SYSTEM_GUIDE.md
|   |-- ELEMENT_TO_LLM_WORKFLOW.md
|   |-- GIT_WORKFLOW_GUIDE.md
|   |-- IMAGE_ASSET_WORKFLOW.md
|   |-- MODEL_DELEGATION_GUIDE.txt
|   |-- TWIG_PATTERNS_GUIDE.md
|   `-- WORKFLOW_QUICK_REFERENCE.md
|
|-- d4-prompts/
|   |-- ds1-setup/
|   |   |-- PROJECT_BOOTSTRAP_PROMPT.md
|   |   |-- RESTORE_POINT_PROMPT.md
|   |   |-- SESSION_HANDOFF_PROMPT.md
|   |   `-- SESSION_BOOTSTRAP_PROMPT.md
|   |
|   |-- ds2-build/
|   |   |-- DESIGN_TOKENS_PROMPT.md
|   |   |-- NEW_CPT_PROMPT.md
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
|   |   `-- GRIDPANE_DEPLOYMENT_PROMPT.md
|   |
|   `-- ds6-git/
|       `-- GIT_OPERATIONS_PROMPT.md
|
`-- d5-examples/
    |-- example-landing-page-build.md
    `-- example-project-context.md
```

## Core Workflow

1. Plan the project in `_project-context.md`
2. Generate or update tokens and schema artifacts in the child theme
3. Generate MB Views Twig and CSS from the field model
4. Record placement decisions in the assignment map
5. Refine the live result with Element to LLM
6. Run review prompts before launch
7. Deploy with the GridPane workflow and track rollout in `DEPLOYMENT_CHECKLIST.md`
8. Use the Git operations prompt when you want assisted commit, push, tag, or release work for the toolkit repo or a child-theme repo

## V1 Scope

Included in v1:
- Blocksy child theme workflows
- Meta Box AIO and MB Views usage
- project bootstrap, session bootstrap, and session handoff
- design tokens, page creation, CPT creation, view reviews, and pre-launch QA
- restore-point safety workflow
- deployment checklist and GridPane deployment workflow
- Git workflow guidance for scaffold timing and code updates
- Git operations prompt for toolkit and child-theme repositories

Deferred from v1:
- generic WordPress theme-authoring guidance outside the Meta Views Stack
- theme.json strategy
- WP.org theme-review compliance workflows
- maintenance prompt families

## Using With AI IDEs

Reference prompts directly in chat:

```text
@SESSION_BOOTSTRAP_PROMPT.md run
```

```text
@SESSION_HANDOFF_PROMPT.md run
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
@GIT_OPERATIONS_PROMPT.md run
```

See `d1-setup/IDE_SETUP_GUIDE.md` and `d3-guides/WORKFLOW_QUICK_REFERENCE.md` for the operating sequence.
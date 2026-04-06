# IDE Setup Guide

This guide explains how to operate the Meta Views Stack toolkit inside VS Code, Cursor, Windsurf, or similar AI IDEs.

## Workspace Setup

Add these folders to the same workspace:

1. `wp-theme-toolkit`
2. the target site project or Blocksy child theme

This allows direct `@` references to toolkit prompts while the AI can also inspect and edit the target site files.

## Files To Keep In Context

For most sessions, keep these files attached or easy to reference:

- `_project-context.md`
- the relevant `.mbjson` file
- the relevant local Twig and CSS reference copy under `views/`
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`
- `d3-guides/TWIG_PATTERNS_GUIDE.md`

## Recommended Session Order

### New project

1. Read `d1-setup/STACK_REFERENCE.md`
2. Read `d1-setup/PROJECT_CONTEXT_TEMPLATE.md`
3. Run `@PROJECT_BOOTSTRAP_PROMPT.md run`
4. Run `@RESTORE_POINT_PROMPT.md run` before broad edits

### Existing project, new chat

1. Run `@SESSION_BOOTSTRAP_PROMPT.md run`
2. Run `@RESTORE_POINT_PROMPT.md run`
3. Continue with build or review prompts

## Element To LLM Usage

Use Element to LLM after the first render, not before. The workflow is:

1. Generate Twig and CSS
2. Paste into MB Views
3. Load the page locally in the browser
4. Capture the relevant section with Element to LLM
5. Paste the capture into chat with the exact refinement goal
6. Apply only the needed Twig and CSS changes

## Model Usage

- Use GPT-5.4 for exploration, planning, bootstrap work, and audits
- Use GPT-5.3 Codex for bounded implementation changes when the design is already clear
- Use a stronger judgment-oriented model for high-stakes accessibility or launch decisions when needed

See `d3-guides/MODEL_DELEGATION_GUIDE.txt` for the detailed routing.

## Operational Rules

- Keep `_project-context.md` current after every material change
- Keep local reference copies of MB Views in files
- Record placement decisions in the placement map
- Run the pre-launch prompt sequence before go-live
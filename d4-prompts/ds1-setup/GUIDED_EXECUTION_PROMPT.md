<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Guided Execution Prompt

This file is a compatibility wrapper.

Canonical shared source:
- `wp-workflow-toolkit/d4-prompts/ds1-session/GUIDED_EXECUTION_PROMPT.md`

Use this wrapper to keep `@GUIDED_EXECUTION_PROMPT.md run` working inside `wp-theme-toolkit`.

## Theme-Specific Notes

- Interpret `target` as a Meta Views Stack site project or Blocksy child theme unless `_TASK_RUNNER.md` allows an explicit atypical target.
- Treat `_project-context.md` as the highest-value target context file when it exists.
- Route specialized follow-up work to this toolkit's prompt families, especially `NEW_PAGE_PROMPT.md`, `NEW_CPT_PROMPT.md`, `VIEW_REVIEW_PROMPT.md`, `CSS_CONSISTENCY_AUDIT_PROMPT.md`, `DESIGN_SYSTEM_COMPLIANCE_PROMPT.md`, and the `01-` through `06-` pre-launch sequence.
- Keep local filenames in chat. `@GUIDED_EXECUTION_PROMPT.md run`, `@SESSION_BOOTSTRAP_PROMPT.md run`, and `@RESTORE_POINT_PROMPT.md run` should continue to refer to this toolkit's local wrapper files.
- Update the shared source first. Edit this wrapper only when theme-specific notes change.
<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Guided Execution Prompt

This file is a compatibility wrapper.

Canonical shared source:
- `wp-workflow-toolkit/d4-prompts/ds1-session/GUIDED_EXECUTION_PROMPT.md`

Use this wrapper to keep `@GUIDED_EXECUTION_PROMPT.md run` working inside `wp-theme-toolkit`.

## Theme-Specific Notes

- Interpret `target` as a Meta Views Stack site project or Blocksy child theme unless `_TASK_RUNNER.md` allows an explicit atypical target.
- Treat `_project-context.md` as the highest-value target context file when it exists.
- Route specialized follow-up work to this toolkit's prompt families, especially `NEW_PAGE_PROMPT.md`, `NEW_CPT_PROMPT.md`, `VIEW_REVIEW_PROMPT.md`, `CSS_CONSISTENCY_AUDIT_PROMPT.md`, `DESIGN_SYSTEM_COMPLIANCE_PROMPT.md`, and the pre-launch sequence: prompts `01` through `05`, `05A-SECURITY_REVIEW_PROMPT.md`, then `06-FINAL_CHECKLIST_PROMPT.md` last.
- Route first-party security review to `05A-SECURITY_REVIEW_PROMPT.md`. Route testing or troubleshooting that requires a confirmed WordPress runtime to `C:\Users\Captain\Documents\AI Workflows\Task Workflows\WordPress\wordpress-component-testing-troubleshooting-debugging-workflow.md`.
- Make the runtime route conditional on meaningful executable behavior, environment state, or a reproducible defect. For static presentation-only work, record why full runtime component testing is not applicable and use the relevant source, visual, and pre-launch checks.
- Keep local filenames in chat. `@GUIDED_EXECUTION_PROMPT.md run`, `@SESSION_BOOTSTRAP_PROMPT.md run`, and `@RESTORE_POINT_PROMPT.md run` should continue to refer to this toolkit's local wrapper files.
- Update the shared source first. Edit this wrapper only when theme-specific notes change.

<!-- Task Type: Two-Phase | See _TASK_RUNNER.md for execution instructions -->

# Toolkit Lessons Audit & Retrospective

This file is a compatibility wrapper.

Canonical shared source:
- `wp-workflow-toolkit/d4-prompts/ds3-maintenance/TOOLKIT_LESSONS_AUDIT_PROMPT.md`

Use this wrapper to keep `@TOOLKIT_LESSONS_AUDIT_PROMPT.md run` working inside `wp-theme-toolkit`.

## Theme-Specific Notes

- The deliberate atypical target is the `wp-theme-toolkit` repository root, not a child theme or site project.
- Treat candidate lessons as toolkit-worthy only when they generalize across Meta Views Stack site-building sessions.
- Typical high-value lesson areas here include Blocksy integration, Meta Box/MB Views workflow, design-system drift, review coverage, deployment guidance, and site-oriented setup gaps.
- `PRE_LAUNCH_CHECKLIST.md` and `DEPLOYMENT_CHECKLIST.md` remain out of scope because this workflow targets toolkit guidance, not a site project.
- Update the shared source first. Edit this wrapper only when theme-specific scope notes change.
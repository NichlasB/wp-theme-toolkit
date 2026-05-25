<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Session Handoff & Context Transfer

This file is a compatibility wrapper.

Canonical shared source:
- `wp-workflow-toolkit/d4-prompts/ds1-session/SESSION_HANDOFF_PROMPT.md`

Use this wrapper to keep `@SESSION_HANDOFF_PROMPT.md run` working inside `wp-theme-toolkit`.

## Theme-Specific Notes

- Interpret the normal target as a Meta Views Stack site project or Blocksy child theme.
- Prefer identity and structure clues from `style.css`, `functions.php`, `_project-context.md`, `mb-json/`, `views/`, and `inc/cpt.php`.
- Treat database-only Blocksy settings, MB Views assignments, content-block placement, CPT visibility, permalink flush needs, and other wp-admin state as unverified unless directly confirmed.
- Route likely follow-up work to this toolkit's build, review, pre-launch, deployment, or git prompt families.
- Keep local filenames in chat and update the shared source first when the common workflow changes.

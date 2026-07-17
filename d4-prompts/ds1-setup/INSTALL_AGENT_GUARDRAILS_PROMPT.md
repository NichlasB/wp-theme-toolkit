<!-- Task Type: Two-Phase | See _TASK_RUNNER.md for execution instructions -->

# Install Or Refresh Agent Engineering Guardrails

This file is the theme-toolkit adapter for the shared project-aware installer.

Canonical shared sources:

- `wp-workflow-toolkit/d4-prompts/ds4-governance/INSTALL_AGENT_GUARDRAILS_CORE_PROMPT.md`
- `wp-workflow-toolkit/d1-setup/agent-guardrails/`

Use this local filename to keep:

```text
@INSTALL_AGENT_GUARDRAILS_PROMPT.md run
```

working inside `wp-theme-toolkit`.

## Theme-Toolkit Adapter Rules

- Apply this toolkit's `_TASK_RUNNER.md`, Git boundary, restore-point route, project context/status conventions, and site follow-up workflows.
- A normal target is a Meta Views Stack site project or Blocksy child theme outside `wp-theme-toolkit`.
- A conventional WordPress theme or child theme is also a valid target for this guardrail prompt, even though the toolkit's build workflows remain Meta Views Stack-specific.
- For this prompt only, an explicitly selected WordPress plugin is an allowed atypical target because the shared core detects all three profiles.
- Do not default every child theme to Meta Views Stack. Require the evidence defined by the shared core; otherwise use the conventional theme profile.
- For Meta Views Stack, read `_project-context.md`, `mvs-project-status.md`, the placement map, view reference locations, Meta Box JSON locations, and stack guides relevant to ownership before finalizing Phase 1.
- Keep the shared common templates and profile files canonical. Do not recreate local copies.
- Route plugin follow-up work to `wp-plugin-toolkit`.
- Route generic theme follow-up only to workflows whose assumptions actually match; do not apply Meta Views Stack build or deployment prompts automatically.
- This governance workflow does not update `PRE_LAUNCH_CHECKLIST.md` or `DEPLOYMENT_CHECKLIST.md`.

Run the shared core in full, including its Phase 1 approval gate and the Meta Views Stack source-versus-database scenario when that profile is selected.

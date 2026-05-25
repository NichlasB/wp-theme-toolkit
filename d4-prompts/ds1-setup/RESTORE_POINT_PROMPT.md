<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Restore Point & Rollback Workflow

This file is a compatibility wrapper.

Canonical shared source:
- `wp-workflow-toolkit/d4-prompts/ds2-safety/RESTORE_POINT_PROMPT.md`

Use this wrapper to keep `@RESTORE_POINT_PROMPT.md run` working inside `wp-theme-toolkit`.

## Theme-Specific Configuration

### Snapshot Root Paths

Check these locations in order unless the user explicitly provides a different destination:

```text
C:\Development\WordPress\toolkit-snapshots
D:\toolkit-snapshots
~/toolkit-snapshots
C:\Users\Captain\Documents\WP Theme Restore Points
D:\WP Theme Restore Points
~/wp-theme-restore-points
```

### Helper Scripts

- Windows / PowerShell: `d2-scripts/restore-point.ps1`
- macOS / Linux / WSL: `d2-scripts/restore-point.sh`

## Theme-Specific Notes

- Interpret the normal target as a site project or Blocksy child theme, excluding `wp-theme-toolkit/` unless explicitly requested.
- Use theme-oriented examples such as `blocksy-child` for target naming.
- Treat rollback as code-state protection only. It does not restore database-backed Blocksy settings, MB Views assignments, or WordPress content.
- Update the shared source first. Edit this wrapper only when theme-specific config or cautions change.
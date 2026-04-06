<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Restore Point & Rollback Workflow

Use this prompt when you want an IDE-agnostic safety layer before edit-heavy work, or when you need to restore the target site project or child theme from a previously created restore point.

This workflow complements `SESSION_BOOTSTRAP_PROMPT.md`.

- `SESSION_BOOTSTRAP_PROMPT.md` explains the target project.
- This workflow protects that target before edits begin and helps you roll back later if needed.

This workflow creates and uses exact external restore points. It is not a substitute for:
- full-site backups
- database backups
- release tags
- environment or secret management

If `session-context.tmp.md` already exists in the target root, you may use it as helper context, but verify rollback-relevant details directly from the current filesystem and git state before making decisions.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `d3-guides/WORKFLOW_QUICK_REFERENCE.md`

---

## Configuration

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

Use the first path whose parent directory already exists.

- If the snapshot root itself does not exist yet, create it.
- Never place the snapshot root inside the target folder.
- If none of the configured parent paths exist, ask the user to provide a destination path.

### Helper Scripts

Use the helper scripts in this toolkit:
- Windows / PowerShell: `d2-scripts/restore-point.ps1`
- macOS / Linux / WSL: `d2-scripts/restore-point.sh`

The helper script is responsible for:
- filesystem safety checks
- exact zip creation
- sidecar metadata creation
- restore preview diffing
- exact rollback apply operations

### Git Checkpoint Naming

When Option C creates a git-native checkpoint, use this local-only branch name pattern:

```text
restore-point/{target-slug}-{YYYYMMDD-HHmmss}
```

Do not push the checkpoint branch automatically.
Do not switch to it automatically.

---

## Quick Reference

| Option | Use when | Default |
|--------|----------|---------|
| `Option A` | You only want a safety report | No |
| `Option B` | You want an external restore point before editing | Yes |
| `Option C` | You want the external restore point plus a clean-tree git checkpoint | No |
| `Option D` | You want a close-out summary against the latest restore point | No |
| `Option E` | You want to preview or apply a rollback | No |

Important rollback rule: Option E must always preview first.

---

## Step 0: Confirm Target

Unless already specified by the user, identify the target site project or child theme (excluding `wp-theme-toolkit/`).

- If one likely target is found, proceed with it
- If multiple likely targets are found, ask the user which one to target
- If the user explicitly targets the toolkit itself or another atypical folder, honor that choice and note it clearly

Determine the target slug from the selected folder name.

---

## Step 1: Resolve Platform, Helper Script, and Snapshot Root

1. Detect the current platform
2. Use the matching helper script
3. Resolve the snapshot root using the configured list unless the user provided one explicitly
4. Pass the resolved target path and snapshot root to the helper script

---

## Option A: Safety Check Only

Run the helper script in `check` mode and report:
- target path
- target name and version when detectable
- git branch and commit when applicable
- clean vs dirty worktree state
- latest restore point if one exists
- whether a git checkpoint would be eligible right now

Good use cases:
- before risky work when the user is not sure whether to checkpoint yet
- when the working tree is already dirty and you want a warning first
- when the user asks whether the target is safe to proceed with

---

## Option B: Create Restore Point

This is the default option when the user does not specify one.

Run the helper script in `create` mode.

Create:
- a timestamped exact zip of the full target folder
- a matching `.txt` sidecar containing restore metadata

Report the exact archive path and sidecar path.

Notes:
- this restore point is the primary safeguard for the session
- do not replace it with a filtered export in this workflow

---

## Option C: Restore Point Plus Git Checkpoint

Use this before broad refactors or larger build passes.

1. Run Option B first
2. Inspect the current git state
3. If the target is a git repo and the worktree is clean, create a local-only checkpoint branch
4. If the repo is dirty, keep the external restore point and clearly report that the git checkpoint was skipped

Do not auto-commit or auto-stash user work.

If the target is not a git repo, or the worktree is dirty:
- skip the git checkpoint
- explain clearly why it was skipped

---

## Option D: Session Close-Out Summary

Use this near the end of a session.

1. Run the helper script in `closeout` mode
2. Compare the current target against the latest restore point
3. Report files that would be restored, replaced, or deleted by a rollback

If no restore point exists:
- say so clearly
- recommend running Option B before the next edit-heavy session

---

## Option E: Restore / Rollback

1. Use the latest restore point unless the user names a specific one
2. Run the helper script in `preview-restore` mode first
3. Report the preview summary
4. If the user requested preview only, stop there
5. If approval is not explicit yet, stop and ask for explicit approval
6. After approval, create a fresh pre-rollback restore point and then apply the selected restore point
7. Recommend re-running `SESSION_BOOTSTRAP_PROMPT.md` after restore completes

Never apply rollback blindly.

Hard rules:
- never skip the preview
- never overwrite the target without explicit approval
- never treat code rollback as database rollback

---

## Modifiers

| Modifier | Example Usage |
|----------|---------------|
| Specific target | `Run on blocksy-child` |
| Specific snapshot path | `Use D:\Theme Restore Points` |
| Explicit option | `Run Option C` |
| Latest restore point | `Use the latest restore point` |
| Specific restore point | `Use restore point blocksy-child-20260406-154200.zip` |
| Preview only | `Preview only` |
| Strict order | `Run this before SESSION_BOOTSTRAP_PROMPT.md` |

---

## Output Format

Summarize the workflow result in this structure:

```text
Target used: [path or target name]
Option used: [A / B / C / D / E]
Snapshot root: [path]
Archive path: [path or none]
Sidecar path: [path or none]
Git checkpoint: [created / skipped / not applicable]
Approval required: [yes / no]
Next step: [short recommendation]
```

When Option E is used, also include the preview counts for restore-only, replace, and delete operations.

---

## Final Assistant Output

Always report:
- target used
- option used
- snapshot root used
- archive path created or selected
- sidecar path when created
- whether a git checkpoint was created, skipped, or not applicable
- rollback preview counts when Option E is used
- whether approval is still required before rollback can continue
- the most relevant next step

Proceed with the restore-point workflow now.
<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# 06 Final Checklist Prompt

Run this last in the pre-launch sequence.

## Purpose

Confirm that the non-template launch details were not missed.

This is the final operational gate before launch. Its job is to catch the practical items that the earlier code and markup reviews do not fully cover.

## Primary References

Read:
- `_TASK_RUNNER.md`
- `_project-context.md`
- `PRE_LAUNCH_CHECKLIST.md`

## Checklist

### 1. Forms and conversions
- [ ] Forms are tested
- [ ] Confirmation, success, and error behavior is known

### 2. Navigation and links
- [ ] Navigation and critical links are verified
- [ ] CTA destinations are correct

### 3. Brand and tracking assets
- [ ] Favicon and social preview assets are set
- [ ] Analytics or tag-manager wiring is confirmed

### 4. Failure and edge routes
- [ ] 404 page exists and is styled
- [ ] Redirects are noted where needed

### 5. Context and assignment sync
- [ ] Placement map and `_project-context.md` reflect final live assignments
- [ ] Local reference files still match what is live in WordPress admin

## Output Format

```text
Checklist items reviewed: [count]
Open launch blockers: [count]
Resolved during review: [count]
Remaining follow-ups: [count]
```

For each blocker or follow-up:

```text
TYPE: [Forms / Links / Assets / Analytics / 404 and Redirects / Context Sync]
ISSUE: [description]
ACTION: [Resolved / Flagged / Needs manual review]
```

If no blockers remain:

```text
Final checklist passed. No open launch blockers remain in the audited scope.
```

Run the final checklist now. Resolve obvious low-risk gaps automatically and flag anything that should block launch until confirmed.
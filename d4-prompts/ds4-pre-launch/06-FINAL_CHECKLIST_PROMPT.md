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
- the completed `05A-SECURITY_REVIEW_PROMPT.md` result
- `C:\Users\Captain\Documents\AI Workflows\Task Workflows\WordPress\wordpress-component-testing-troubleshooting-debugging-workflow.md` only when runtime component testing was applicable

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

### 6. Security and runtime evidence
- [ ] The final `05A` status is recorded as `Clean`, `No updates needed`, `Partially verified`, or `Blocked`
- [ ] Any unresolved `05A` finding or unavailable security evidence is identified as a launch blocker
- [ ] Runtime component testing has exactly one disposition: `Applicable - passed`, `Not applicable`, or `Blocked`
- [ ] An `Applicable - passed` disposition points to focused evidence from the standalone WordPress component-testing workflow
- [ ] A `Not applicable` disposition includes a concrete rationale, such as presentation-only work with no meaningful executable behavior
- [ ] A `Blocked` disposition states what remains unproven and is treated as a launch blocker

This final gate verifies existing evidence; it does not initiate broad adversarial tests against a live site. If focused runtime evidence is missing, route the case back through the standalone workflow and follow its Site Operations target-confirmation and approval gates.

## Output Format

```text
Checklist items reviewed: [count]
Open launch blockers: [count]
Resolved during review: [count]
Remaining follow-ups: [count]
Final 05A status: [Clean / No updates needed / Partially verified / Blocked]
Runtime component testing: [Applicable - passed / Not applicable / Blocked]
Runtime evidence or rationale: [reference or concise explanation]
```

For each blocker or follow-up:

```text
TYPE: [Forms / Links / Assets / Analytics / 404 and Redirects / Context Sync / Security / Runtime Testing]
ISSUE: [description]
ACTION: [Resolved / Flagged / Needs manual review]
```

If no blockers remain:

```text
Final checklist passed. No open launch blockers remain in the audited scope.
```

Run the final checklist now. Resolve obvious low-risk gaps automatically and flag anything that should block launch until confirmed.

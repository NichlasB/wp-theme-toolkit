<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# 05 Cross-Browser QA Prompt

Run this fifth in the pre-launch sequence.

## Purpose

Check for common cross-browser frontend risks before launch.

This is a focused compatibility pass, not a full manual browser lab.

## Primary References

Read:
- `_TASK_RUNNER.md`
- `_project-context.md`
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`

## Checklist

### 1. Layout assumptions
- [ ] Grid and flex layouts do not depend on brittle assumptions
- [ ] Gap, alignment, and equal-height expectations are not fragile

### 2. Typography and font loading
- [ ] Font loading strategy is sane
- [ ] The layout does not collapse if a preferred font loads late or fails

### 3. Controls and interactions
- [ ] Form controls and buttons are not styled in a browser-fragile way
- [ ] Hover-only affordances are not the only state signal

### 4. CSS feature risk
- [ ] Overflow, sticky, and object-fit usage are reviewed where relevant
- [ ] Known fallback gaps are flagged

## Output Format

```text
Views reviewed: [count]
Cross-browser issues found: [count]
Issues auto-fixed: [count]
Manual follow-ups: [count]
```

For each issue:

```text
TYPE: [Layout / Typography / Controls / CSS Feature Risk]
FILE: [filename:line]
ISSUE: [description]
ACTION: [Fixed / Flagged / Needs manual review]
```

If no issues:

```text
Cross-browser QA passed. No obvious compatibility risks found in the audited views.
```

Run the cross-browser QA now. Fix obvious low-risk issues automatically and flag anything that needs manual browser verification.
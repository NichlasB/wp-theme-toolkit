<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# 04 Performance Review Prompt

Run this fourth in the pre-launch sequence.

## Purpose

Review template output and assets for obvious frontend performance risks.

Focus on practical launch risks rather than theoretical micro-optimizations.

## Primary References

Read:
- `_TASK_RUNNER.md`
- `_project-context.md`
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`

## Checklist

### 1. Image weight and rendering
- [ ] Large images are appropriately sized
- [ ] Responsive image behavior is sensible for the layout

### 2. Loading behavior
- [ ] Lazy loading is used where sensible
- [ ] Heavy media and embeds are not front-loaded without reason

### 3. CSS and markup efficiency
- [ ] CSS is not bloated with repeated patterns
- [ ] Markup is not over-nested without value

### 4. Interactive payloads
- [ ] Heavy embeds or forms are placed intentionally
- [ ] Repeated sections are not causing unnecessary duplicate weight

## Output Format

```text
Views reviewed: [count]
Performance issues found: [count]
Issues auto-fixed: [count]
Manual follow-ups: [count]
```

For each issue:

```text
TYPE: [Images / Loading / CSS and Markup / Embeds and Forms]
FILE: [filename:line]
ISSUE: [description]
ACTION: [Fixed / Flagged / Needs manual review]
```

If no issues:

```text
Performance review passed. No significant launch-blocking frontend performance issues found.
```

Run the performance review now. Fix obvious low-risk issues automatically and flag anything that requires broader product or hosting decisions.
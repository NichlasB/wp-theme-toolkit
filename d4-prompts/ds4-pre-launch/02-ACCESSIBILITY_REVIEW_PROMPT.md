<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# 02 Accessibility Review Prompt

Run this second in the pre-launch sequence.

## Purpose

Review launch-relevant views for semantic HTML, alt text, focus states, contrast risks, and general WCAG 2.1 AA issues.

## Primary References

Read:
- `_TASK_RUNNER.md`
- `_project-context.md`
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`
- `d3-guides/TWIG_PATTERNS_GUIDE.md`

## Scope

Review the launch-relevant frontend pages, views, and interactive sections. Focus on semantic markup, readable structure, and user interaction rather than theoretical full-platform accessibility coverage.

## Checklist

### 1. Structure and headings
- [ ] Heading structure is logical
- [ ] Landmarks and semantic elements are used sensibly

### 2. Images and media
- [ ] Decorative vs informative image treatment is sensible
- [ ] Alt behavior is helpful rather than noisy

### 3. Forms and controls
- [ ] Interactive controls have clear labels
- [ ] Form controls and CTA sections are understandable without visual guesswork

### 4. Focus and keyboard behavior
- [ ] Focus states are visible
- [ ] Interactive elements remain keyboard-usable where relevant

### 5. Color and state communication
- [ ] No meaning depends on color alone
- [ ] Error or emphasis states are not communicated by color only

## Output Format

```text
Views reviewed: [count]
Accessibility issues found: [count]
Issues auto-fixed: [count]
Manual follow-ups: [count]
```

For each issue:

```text
TYPE: [Structure / Images / Controls / Focus / Color and State]
FILE: [filename:line]
ISSUE: [description]
ACTION: [Fixed / Flagged / Needs manual review]
```

If no issues:

```text
Accessibility review passed. No significant launch-blocking a11y issues found.
```

Run the accessibility review now. Fix obvious low-risk issues automatically and flag anything that needs manual judgment.
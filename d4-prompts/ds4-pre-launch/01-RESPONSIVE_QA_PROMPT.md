<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# 01 Responsive QA Prompt

Run this first in the pre-launch sequence.

## Purpose

Check all launch-relevant views for breakpoint coverage at desktop, tablet, and mobile widths.

This is the first launch gate because obvious layout failures should be found before deeper launch review work.

## Primary References

Read:
- `_TASK_RUNNER.md`
- `_project-context.md`
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`

## Scope

Review the pages and views that matter for launch, including homepage, key landing pages, archives, single templates, and any forms or CTA-heavy sections.

## Checklist

### 1. Layout collapse
- [ ] Multi-column sections collapse correctly by `900px`
- [ ] Card grids collapse to one column by `600px` where needed

### 2. Overflow and spacing
- [ ] No horizontal overflow exists
- [ ] Section padding and gap rhythm still feel intentional at smaller widths

### 3. Media behavior
- [ ] Images and embeds scale correctly
- [ ] Cropping, aspect ratio, and object-fit behavior do not break the layout

### 4. Interaction behavior
- [ ] Buttons and forms remain usable on smaller screens
- [ ] Tap targets and stacked controls remain readable and usable

## Output Format

```text
Pages or views reviewed: [count]
Responsive issues found: [count]
Issues auto-fixed: [count]
Manual follow-ups: [count]
```

For each issue:

```text
TYPE: [Layout Collapse / Overflow / Media / Forms / Breakpoint]
FILE: [filename:line]
ISSUE: [description]
ACTION: [Fixed / Flagged / Needs manual review]
```

If no issues:

```text
Responsive QA passed. No significant launch-blocking layout issues found.
```

Run responsive QA now. Fix obvious low-risk layout issues automatically and flag anything that requires a design decision.
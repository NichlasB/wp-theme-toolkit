<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Design System Compliance Prompt

Use this prompt for a fuller audit of templates and CSS against the design system.

Use it when you want a broader standards pass across related templates, not just a quick changed-file review.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `_project-context.md` in the target project
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`
- `d3-guides/TWIG_PATTERNS_GUIDE.md`

Treat `DESIGN_SYSTEM_GUIDE.md` as the default standard and `_project-context.md` as the project-specific override layer.

---

## Audit Scope

Review the relevant local Twig and CSS files together. Include any paired `.mbjson` or placement-map entries only when they matter to understanding the design-system decision.

---

## Checklist

### 1. Token adherence
- [ ] Token usage is consistent across views
- [ ] Palette roles are used consistently
- [ ] View CSS is not bypassing the shared token block

### 2. Layout pattern adherence
- [ ] Wrapper, grid, and card patterns are reused consistently
- [ ] Similar sections do not drift into competing layout systems

### 3. Typography adherence
- [ ] Typography hierarchy stays on the documented scale
- [ ] Display, heading, and body usage feels intentional rather than arbitrary

### 4. Naming and markup adherence
- [ ] Twig classes match the naming convention
- [ ] Similar fragments use consistent markup when they represent the same pattern

### 5. Reuse and drift
- [ ] Reusable fragments are not drifting across similar views
- [ ] Near-duplicate sections are identified for cleanup or alignment

### 6. Placement-map alignment
- [ ] Placement-map entries exist for live artifacts that depend on assignment rules
- [ ] Local reference files can still be matched to the live assignment notes

### 7. Safe fixes and manual decisions
- [ ] Obvious low-risk consistency fixes are applied automatically
- [ ] Broader style-direction decisions are flagged instead of guessed

---

## Output Format

```text
Audit scope: [brief description]
Files reviewed: [count]
Project-specific overrides considered: [count or none]
Compliance issues found: [count]
Issues auto-fixed: [count]
Manual follow-ups: [count]
```

For each issue:

```text
TYPE: [Tokens / Layout / Typography / Naming / Reuse / Placement Map]
FILE: [filename:line]
ISSUE: [description]
ACTION: [Fixed / Flagged / Needs manual review]
```

If no issues:

```text
Design-system compliance looks solid across the audited files. No significant drift found.
```

Run the compliance audit now. Fix obvious low-risk issues automatically and flag anything that changes the project's intended visual direction.
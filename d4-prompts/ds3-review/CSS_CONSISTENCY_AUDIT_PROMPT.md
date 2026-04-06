<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# CSS Consistency Audit Prompt

Use this prompt to scan multiple views for hardcoded colors, spacing drift, layout-pattern violations, and inconsistent responsive rules.

Use it when one view review is no longer enough because drift may exist across several related files.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `_project-context.md` in the target project
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`

Treat the design system guide as the standard and the project context as the project-specific override layer.

---

## Audit Scope

Audit all relevant local view CSS files and any paired Twig files needed to confirm naming and layout intent.

Prefer the local file copies under `views/` as the audit target. If the live MB View content differs, flag that mismatch explicitly.

---

## Checklist

### 1. Color consistency
- [ ] No hardcoded colors remain in view CSS
- [ ] Colors map cleanly to Blocksy palette roles

### 2. Spacing and rhythm consistency
- [ ] No raw spacing values remain in view CSS
- [ ] Section rhythm uses the documented spacing scale
- [ ] Card and grid gaps are consistent where the pattern is intended to match

### 3. Breakpoint consistency
- [ ] No unsupported breakpoints remain in view CSS
- [ ] Tablet and mobile collapse behavior is predictable across similar components

### 4. Layout-pattern consistency
- [ ] Repeated layout patterns use the documented grid and wrapper system
- [ ] Flexbox is not being used where Grid is the intended standard

### 5. Naming consistency
- [ ] Class naming is consistent across related views
- [ ] Similar components do not use competing naming schemes

### 6. Safe fixes
- [ ] Obvious low-risk CSS inconsistencies are fixed automatically

---

## Output Format

```text
CSS files reviewed: [count]
Twig files checked for context: [count]
Issues found: [count]
Issues auto-fixed: [count]
Manual follow-ups: [count]
```

For each issue:

```text
TYPE: [Color / Spacing / Breakpoint / Naming / Layout Pattern]
FILE: [filename:line]
ISSUE: [description]
ACTION: [Fixed / Flagged / Needs manual review]
```

If the audit reveals broader design drift:

```text
FOLLOW-UP REVIEW RECOMMENDED:
- DESIGN_SYSTEM_COMPLIANCE_PROMPT.md
- Reason: [why]
```

Audit the selected CSS now. Fix obvious low-risk inconsistencies automatically, keep changes scoped, and flag anything that requires a design decision.
<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# View Review Prompt

Use this prompt after generating or changing an MB View.

Its job is to review the changed view for accessibility, responsive behavior, design-system compliance, and placement clarity.

This is the first review pass for a changed view. It is not a replacement for the broader CSS or design-system audits when multiple views changed.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `_project-context.md` in the target project
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`
- `d3-guides/TWIG_PATTERNS_GUIDE.md`
- `d3-guides/BLOCKSY_INTEGRATION_GUIDE.md`

Use these files to verify both the view markup and the assignment logic around it.

---

## Review Scope

Review only:
- the changed Twig and CSS files
- the live placement decision or placement map entry that explains where the view appears
- any directly related `.mbjson` or CPT registration file needed for context

Do not turn this into a full-project audit unless the user asked for that. Keep the focus on the changed view and the directly affected call sites.

---

## Checklist

### 1. Structure and semantics
- [ ] Headings are in a sensible order
- [ ] Semantic elements are used where appropriate
- [ ] Links and buttons are used correctly
- [ ] Empty or fallback states will not render as broken output

### 2. Design-system compliance
- [ ] All spacing uses `var(--space-*)`
- [ ] All colors use `var(--theme-palette-color-N)`
- [ ] Only `900px` and `600px` breakpoints are used
- [ ] Naming follows `.mv-{name}` and `.mv-{name}--{element}`
- [ ] Wrapper, grid, and card patterns match the documented system

### 3. Responsive behavior
- [ ] Multi-column layouts collapse correctly
- [ ] Images do not overflow
- [ ] Text does not create obvious wrapping problems
- [ ] Buttons and embedded media stay usable at smaller widths

### 4. Content-model alignment
- [ ] The Twig field access matches the intended single or archive context
- [ ] Optional fields are guarded with sensible conditionals
- [ ] Image fields use a defensive pattern
- [ ] Shortcode usage is rendered with the documented `do_shortcode` pattern when needed

### 5. Placement and reuse
- [ ] The placement decision is clear
- [ ] The placement map entry exists or is updated
- [ ] The local reference copy reflects the live MB View content
- [ ] Similar reusable fragments are not drifting from the project standard

### 6. Escalation rules
- [ ] If multiple views changed or CSS drift appears widespread, run `CSS_CONSISTENCY_AUDIT_PROMPT.md`
- [ ] If the issues point to broader pattern drift, run `DESIGN_SYSTEM_COMPLIANCE_PROMPT.md`
- [ ] If this review is happening near launch, remind that the six-step pre-launch sequence is still required

---

## Output Format

Start with:

```text
View scope: [brief description]
Files reviewed: [count]
Risk areas touched: [Semantics / Responsive / Data Access / Placement / Reuse]
Issues found: [count]
Issues auto-fixed: [count]
Issues requiring manual decision: [count]
```

For each issue:

```text
TYPE: [Semantics / Design System / Responsive / Data Access / Placement]
FILE: [filename:line]
ISSUE: [description]
ACTION: [Fixed / Flagged / Needs manual review]
```

If a deeper review should run next:

```text
FOLLOW-UP REVIEW RECOMMENDED:
- [prompt name]
- Reason: [why]
```

If no issues:

```text
View passes review. No significant issues found in the changed files.
```

Review the changed view now. Fix obvious low-risk issues automatically, keep changes tightly scoped, and flag anything that needs a manual decision.
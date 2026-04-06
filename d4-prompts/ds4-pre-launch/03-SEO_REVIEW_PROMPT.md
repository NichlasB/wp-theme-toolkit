<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# 03 SEO Review Prompt

Run this third in the pre-launch sequence.

## Purpose

Review heading hierarchy, image metadata habits, schema opportunities, and page-level discoverability concerns.

Keep the review grounded in what the theme, templates, and page structure actually control. Do not invent metadata systems the project does not currently use.

## Primary References

Read:
- `_TASK_RUNNER.md`
- `_project-context.md`
- `d3-guides/TWIG_PATTERNS_GUIDE.md`

## Checklist

### 1. Document structure
- [ ] Each page has a clear heading hierarchy
- [ ] Important pages expose clear CTA and content structure

### 2. Titles, slugs, and discoverability
- [ ] Slug or title inconsistencies are flagged
- [ ] Archive and single templates present content clearly enough for discovery intent

### 3. Images and media
- [ ] Images have sensible alt behavior
- [ ] Important visual sections do not hide essential meaning behind decorative presentation only

### 4. Structured-data opportunities
- [ ] Obvious schema opportunities are noted
- [ ] Existing structured-data assumptions are not contradicted by the template markup

### 5. Internal content signals
- [ ] Navigation, cards, and CTA surfaces expose meaningful text and link structure

## Output Format

```text
Pages reviewed: [count]
SEO issues found: [count]
Issues auto-fixed: [count]
Manual follow-ups: [count]
```

For each issue:

```text
TYPE: [Structure / Titles and Slugs / Images / Schema / Internal Signals]
FILE: [filename:line]
ISSUE: [description]
ACTION: [Fixed / Flagged / Needs manual review]
```

If no issues:

```text
SEO review passed. No significant template-driven SEO issues found.
```

Run the SEO review now. Fix obvious low-risk issues automatically and flag anything that depends on broader content or plugin decisions.
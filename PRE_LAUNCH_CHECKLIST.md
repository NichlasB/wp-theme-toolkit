# Site Launch Checklist

Track bootstrap workflows, build workflows, review workflows, and pre-launch reviews for each site project in one place.

## How to use

1. Copy the template at the bottom for each new project.
2. Keep one consistently structured entry per project.
3. When a supported workflow completes successfully, update the matching row immediately.
4. Use the Notes column when a workflow was intentionally skipped or partially replaced by a project-specific decision.

## Sections per project

- Setup & Build - project bootstrap, session bootstrap, tokens, pages, and CPT work
- Review Workflows - view review and design-system audits
- Pre-Launch Reviews - the ordered 01-06 launch sequence
- Launch Notes - final notes, blockers, or follow-up work

---

## Project: Example Site
**Primary Theme Root:** /path/to/blocksy-child
**Started:** 2026-04-06
**Launch Date:** -

### Setup & Build

| Workflow | Done | Date | Notes |
|----------|------|------|-------|
| Project Bootstrap | [ ] | | |
| Session Bootstrap | [ ] | | |
| Design Tokens | [ ] | | |
| New Page Build | [ ] | | |
| New CPT Build | [ ] | | |

### Review Workflows

| Workflow | Done | Date | Notes |
|----------|------|------|-------|
| View Review | [ ] | | |
| CSS Consistency Audit | [ ] | | |
| Design System Compliance Audit | [ ] | | |

### Pre-Launch Reviews

| # | Prompt | Done | Date | Notes |
|---|--------|------|------|-------|
| 01 | Responsive QA | [ ] | | |
| 02 | Accessibility Review | [ ] | | |
| 03 | SEO Review | [ ] | | |
| 04 | Performance Review | [ ] | | |
| 05 | Cross-Browser QA | [ ] | | |
| 06 | Final Checklist | [ ] | | |

### Launch Notes

| Item | Status | Notes |
|------|--------|-------|
| Forms tested | Pending | |
| Analytics connected | Pending | |
| 404 page verified | Pending | |
| Redirects verified | Pending | |

---

## Project: WP Theme Toolkit
**Primary Theme Root:** C:\Development\WordPress\Plugins\wp-theme-toolkit
**Started:** 2026-04-06
**Launch Date:** -

### Setup & Build

| Workflow | Done | Date | Notes |
|----------|------|------|-------|
| Project Bootstrap | [ ] | | |
| Session Bootstrap | [x] | 2026-04-09 | Atypical target: toolkit repo orientation at repository root. |
| Design Tokens | [ ] | | |
| New Page Build | [ ] | | |
| New CPT Build | [ ] | | |

### Review Workflows

| Workflow | Done | Date | Notes |
|----------|------|------|-------|
| View Review | [ ] | | |
| CSS Consistency Audit | [ ] | | |
| Design System Compliance Audit | [ ] | | |

### Pre-Launch Reviews

| # | Prompt | Done | Date | Notes |
|---|--------|------|------|-------|
| 01 | Responsive QA | [ ] | | |
| 02 | Accessibility Review | [ ] | | |
| 03 | SEO Review | [ ] | | |
| 04 | Performance Review | [ ] | | |
| 05 | Cross-Browser QA | [ ] | | |
| 06 | Final Checklist | [ ] | | |

### Launch Notes

| Item | Status | Notes |
|------|--------|-------|
| Forms tested | Pending | Atypical target; not applicable unless toolkit ships a live demo site. |
| Analytics connected | Pending | |
| 404 page verified | Pending | |
| Redirects verified | Pending | |

---

## Project: DrMorses.TV
**Primary Theme Root:** C:\Users\Captain\Local Sites\drmorsestv\app\public\wp-content\themes\blocksy-child
**Started:** 2026-04-09
**Launch Date:** -

### Setup & Build

| Workflow | Done | Date | Notes |
|----------|------|------|-------|
| Project Bootstrap | [x] | 2026-04-09 | Existing child theme normalized; canonical token block, context file, scaffold folders, and checklist entry created/updated. |
| Session Bootstrap | [x] | 2026-04-12 | `session-context.tmp.md` written to child theme root; active build state, homepage focus, partial placement map. |
| Design Tokens | [ ] | | |
| New Page Build | [ ] | | |
| New CPT Build | [ ] | | |

### Review Workflows

| Workflow | Done | Date | Notes |
|----------|------|------|-------|
| View Review | [ ] | | |
| CSS Consistency Audit | [ ] | | |
| Design System Compliance Audit | [ ] | | |

### Pre-Launch Reviews

| # | Prompt | Done | Date | Notes |
|---|--------|------|------|-------|
| 01 | Responsive QA | [ ] | | |
| 02 | Accessibility Review | [ ] | | |
| 03 | SEO Review | [ ] | | |
| 04 | Performance Review | [ ] | | |
| 05 | Cross-Browser QA | [ ] | | |
| 06 | Final Checklist | [ ] | | |

### Launch Notes

| Item | Status | Notes |
|------|--------|-------|
| Forms tested | Pending | |
| Analytics connected | Pending | |
| 404 page verified | Pending | |
| Redirects verified | Pending | |

---

## Template

```text
## Project: [site name]
**Primary Theme Root:** [path]
**Started:** [YYYY-MM-DD]
**Launch Date:** -

### Setup & Build
| Workflow | Done | Date | Notes |
|----------|------|------|-------|
| Project Bootstrap | [ ] | | |
| Session Bootstrap | [ ] | | |
| Design Tokens | [ ] | | |
| New Page Build | [ ] | | |
| New CPT Build | [ ] | | |

### Review Workflows
| Workflow | Done | Date | Notes |
|----------|------|------|-------|
| View Review | [ ] | | |
| CSS Consistency Audit | [ ] | | |
| Design System Compliance Audit | [ ] | | |

### Pre-Launch Reviews
| # | Prompt | Done | Date | Notes |
|---|--------|------|------|-------|
| 01 | Responsive QA | [ ] | | |
| 02 | Accessibility Review | [ ] | | |
| 03 | SEO Review | [ ] | | |
| 04 | Performance Review | [ ] | | |
| 05 | Cross-Browser QA | [ ] | | |
| 06 | Final Checklist | [ ] | | |

### Launch Notes
| Item | Status | Notes |
|------|--------|-------|
| Forms tested | Pending | |
| Analytics connected | Pending | |
| 404 page verified | Pending | |
| Redirects verified | Pending | |
```

## Next Step After Pre-Launch

When a project passes the 01-06 review sequence, continue with `DEPLOYMENT_CHECKLIST.md` and run `@GRIDPANE_DEPLOYMENT_PROMPT.md run`.
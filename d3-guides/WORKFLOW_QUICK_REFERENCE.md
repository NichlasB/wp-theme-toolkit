# Workflow Quick Reference

This is the fast route map for operating `wp-theme-toolkit` day to day.

## New Site Project

```text
1.  Read d1-setup/STACK_REFERENCE.md
2.  Read d1-setup/PROJECT_CONTEXT_TEMPLATE.md
3.  @PROJECT_BOOTSTRAP_PROMPT.md run
4.  @RESTORE_POINT_PROMPT.md run
5.  @DESIGN_TOKENS_PROMPT.md run
6.  @NEW_PAGE_PROMPT.md run and/or @NEW_CPT_PROMPT.md run
7.  @VIEW_REVIEW_PROMPT.md run
8.  @CSS_CONSISTENCY_AUDIT_PROMPT.md run
9.  @DESIGN_SYSTEM_COMPLIANCE_PROMPT.md run
10. Pre-launch: run 01 through 06 in order
```

## New Chat On Existing Project

```text
1.  @SESSION_BOOTSTRAP_PROMPT.md run
2.  @RESTORE_POINT_PROMPT.md run
3.  Review session-context.tmp.md and session-handoff.tmp.md when present
4.  Continue with build, review, or pre-launch workflows
```

## End A Working Chat

```text
1.  @SESSION_HANDOFF_PROMPT.md run
2.  Save the code-block Context Transfer Prompt for the next chat
3.  If the chat exposed toolkit-worthy lessons, run @TOOLKIT_LESSONS_AUDIT_PROMPT.md run against wp-theme-toolkit
4.  In the next chat, review session-handoff.tmp.md and session-context.tmp.md when present
```

Use `@TOOLKIT_LESSONS_AUDIT_PROMPT.md run` only when the lesson would improve the toolkit for future site projects.
Do not use it for one-off project bugs, normal build/review work that went fine, or preferences that only apply to the current site.

## Improve The Toolkit

```text
1.  Finish the working chat or review pass
2.  Run @TOOLKIT_LESSONS_AUDIT_PROMPT.md run against wp-theme-toolkit
3.  Review toolkit-lessons.tmp.md and mark approve / reject / defer
4.  Run @TOOLKIT_LESSONS_AUDIT_PROMPT.md run phase 2 when you want approved lessons applied
```

Do not use this workflow as a substitute for project review, pre-launch QA, or session handoff.
If the issue belongs only to the current site project, fix it in the project and keep the toolkit unchanged.

## Git Operations

```text
1.  Confirm whether the target is wp-theme-toolkit or a child-theme repo
2.  @GIT_OPERATIONS_PROMPT.md run
3.  Choose Option A, B, C, or D
4.  For child-theme repos, keep database-only content out of the Git summary
```

Strict-order variant:

```text
1.  @RESTORE_POINT_PROMPT.md run
2.  @SESSION_BOOTSTRAP_PROMPT.md run
```

## Add A New Page

```text
1.  Confirm _project-context.md is current
2.  @NEW_PAGE_PROMPT.md run
3.  Paste Twig and CSS into MB Views
4.  Record the assignment in the placement map
5.  @VIEW_REVIEW_PROMPT.md run
```

## Add A New CPT

```text
1.  Confirm _project-context.md is current
2.  @NEW_CPT_PROMPT.md run
3.  Create or update inc/cpt.php and mb-json/*.mbjson
4.  Create the single and archive views
5.  Record both assignments in the placement map
6.  Run the review prompts
```

## Review After A View Change

```text
1.  @VIEW_REVIEW_PROMPT.md run
2.  @CSS_CONSISTENCY_AUDIT_PROMPT.md run when multiple views changed
3.  @DESIGN_SYSTEM_COMPLIANCE_PROMPT.md run before larger milestones
```

## Pre-Launch Order

| # | Prompt | What It Catches |
|---|--------|-----------------|
| 01 | Responsive QA | breakpoint coverage, overflow, stacking issues |
| 02 | Accessibility Review | semantics, alt text, focus states, WCAG issues |
| 03 | SEO Review | heading hierarchy, metadata, image and schema issues |
| 04 | Performance Review | image sizes, lazy loading, CSS efficiency |
| 05 | Cross-Browser QA | CSS support issues, fallback gaps, rendering risks |
| 06 | Final Checklist | forms, links, analytics, favicon, 404, redirects |

## Common Tooling Workflow

| Workflow | Default Model | Notes |
|----------|---------------|-------|
| Session bootstrap | GPT-5.4 Mini or GPT-5.4 | Use the larger model for older or larger projects |
| Session handoff | GPT-5.4 Mini or GPT-5.4 | Use when pausing work or switching to a fresh chat |
| Restore point | GPT-5.4 Mini or GPT-5.4 | Preview before rollback |
| Project bootstrap | GPT-5.4 | Best when planning and file generation happen together |
| New page / new CPT | GPT-5.4 then GPT-5.3 Codex | Explore first, then implement |
| Toolkit lessons audit | GPT-5.4 then GPT-5.3 Codex | Use when a working chat exposed reusable toolkit lessons or repeated mistakes |
| Launch reviews | GPT-5.4, Sonnet, or stronger judgment model as needed | Use deeper review for accessibility and final launch judgment |

Do not run the toolkit lessons audit for project-specific styling issues, content-entry mistakes, or isolated deployment problems unless they exposed a reusable gap in the toolkit itself.

## Copy-Paste Prompts

Session bootstrap:

```text
@SESSION_BOOTSTRAP_PROMPT.md run
```

Session handoff:

```text
@SESSION_HANDOFF_PROMPT.md run
```

Create restore point:

```text
@RESTORE_POINT_PROMPT.md run
```

Bootstrap new project:

```text
@PROJECT_BOOTSTRAP_PROMPT.md run
```

Build a page:

```text
@NEW_PAGE_PROMPT.md run
```

Run launch sequence starting at step 01:

```text
@01-RESPONSIVE_QA_PROMPT.md run
```

Git operations:

```text
@GIT_OPERATIONS_PROMPT.md run
```

Toolkit lessons audit:

```text
@TOOLKIT_LESSONS_AUDIT_PROMPT.md run
```
# Workflow Quick Reference

This is the fast route map for operating `wp-theme-toolkit` day to day.

## Context Refresh Rule

Before a major phase transition, long-session continuation, context-compaction recovery, or deployment-risk task, refresh from:

```text
START_HERE_MASTER_WORKFLOW.md
_project-context.md
mvs-project-status.md
the next routed prompt
```

Also read session handoff/context files, LocalWP database guidance, Claude Design handoff guidance, or deployment checklists when the task touches those areas.

## New Site Project

```text
1.  @START_HERE_MASTER_WORKFLOW.md run
2.  Follow the detected route into intake, Claude Design handoff, bootstrap, build, review, deploy, or maintenance
3.  Read d1-setup/STACK_REFERENCE.md when routed into setup or build work
4.  Read d1-setup/LOCALWP_DATABASE_ACCESS_WORKFLOW.md when LocalWP SQL or migration work is likely
5.  @PROJECT_BOOTSTRAP_PROMPT.md run
6.  @RESTORE_POINT_PROMPT.md run
7.  @DESIGN_TOKENS_PROMPT.md run
8.  @DESIGN_HANDOFF_TO_MVS_PROMPT.md run when a Claude Design/mockup/HTML handoff exists
9.  @NEW_PAGE_PROMPT.md run and/or @NEW_CPT_PROMPT.md run
10. @VIEW_REVIEW_PROMPT.md run
11. @CSS_CONSISTENCY_AUDIT_PROMPT.md run
12. @DESIGN_SYSTEM_COMPLIANCE_PROMPT.md run
13. Pre-launch: run 01 through 05, then 05A, then 06 last
```

## New Chat On Existing Project

```text
1.  @START_HERE_MASTER_WORKFLOW.md run
2.  @SESSION_BOOTSTRAP_PROMPT.md run when routed into existing project resume
3.  Read d1-setup/LOCALWP_DATABASE_ACCESS_WORKFLOW.md before LocalWP SQL, migration, or reconciliation work
4.  @GUIDED_EXECUTION_PROMPT.md run
5.  @RESTORE_POINT_PROMPT.md run
6.  Review mvs-project-status.md, session-context.tmp.md, and session-handoff.tmp.md when present
7.  Continue with build, review, or pre-launch workflows
```

Use `@GUIDED_EXECUTION_PROMPT.md run` after session bootstrap when the user wants lower-overwhelm pacing, explicit progress tracking, or one approved task slice at a time. If the next specialized workflow is already obvious and the user wants a faster pass, you can skip it.

## LocalWP Database Work

```text
1.  Read d1-setup/LOCALWP_DATABASE_ACCESS_WORKFLOW.md
2.  Resolve LocalWP metadata from sites.json when needed
3.  Use LocalWP's bundled mysql.exe, not wp-load.php, for initial SQL access
4.  Run baseline SELECT counts before destructive changes
5.  Re-run reconciliation queries immediately after changes
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

## Post-Launch Update

```text
1.  Confirm whether the target is staging or production
2.  Classify the change as code only, code + uploads, code + selected DB-content, or full refresh
3.  @POST_LAUNCH_GRIDPANE_UPDATE_PROMPT.md run
4.  Use clean deployment mode when the child-theme repo contains non-runtime notes or migration artifacts you do not want on the server
5.  Keep production DB overwrite approval explicit
```

## Refresh LocalWP From GridPane

```text
1.  Confirm the source is GridPane staging or production
2.  Confirm the target is the matching LocalWP site
3.  @LOCALWP_REVERSE_REFRESH_PROMPT.md run
4.  Review likely local-only database changes before replacing the LocalWP DB
5.  Keep the LocalWP database backup requirement in place before import
6.  Keep uploads missing-only unless overwrite is explicitly approved
7.  Keep code movement in Git and out of this workflow
```

Use this when local needs current production or staging content before new development, QA, troubleshooting, or post-launch refinement.
If the local database may contain work worth preserving, run `@LOCALWP_REVERSE_REFRESH_PROMPT.md review local changes only` first.

Strict-order variant:

```text
1.  @RESTORE_POINT_PROMPT.md run
2.  @SESSION_BOOTSTRAP_PROMPT.md run
3.  @GUIDED_EXECUTION_PROMPT.md run
```

## Add A New Page

```text
1.  Confirm _project-context.md is current
2.  Run the page decision tree below
3.  @PAGE_SCOPING_CHECKLIST_PROMPT.md run when the page shape is not obvious
4.  @NEW_PAGE_PROMPT.md run
5.  Paste Twig and CSS into MB Views
6.  Record the assignment in the placement map
7.  @VIEW_REVIEW_PROMPT.md run
```

## Page Decision Tree

```text
Start
|
+-- Many entries, own URLs, archives, or taxonomies?
|   |
|   +-- Yes -> CPT -> @NEW_CPT_PROMPT.md run
|   |
|   +-- No -> Normal page
|
+-- Mostly one URL with page-unique sections?
|   |
|   +-- Yes -> One page-level MB View
|   |
|   +-- No -> Split reusable parts into section views
|
+-- Editor needs to change it in wp-admin?
|   |
|   +-- Yes -> Add page-targeted fields only for those parts
|   |
|   +-- No -> Keep it static in Twig
|
+-- Reused across pages or placement-driven?
	|
	+-- Yes -> views/sections/ plus Blocksy Content Block when needed
	|
	+-- No -> Keep it in the main page Twig file
```

Practical default:

```text
one page
one field group
one MB View
one Twig file with all page-unique sections
one CSS file
split only reused sections
promote to CPT only when the content wants its own lifecycle
```

## Claude Design Or Visual Handoff

```text
1.  @START_HERE_MASTER_WORKFLOW.md run
2.  Read d3-guides/CLAUDE_DESIGN_HANDOFF_WORKFLOW.md
3.  Generate or refine the Claude Design prompt when needed
4.  Gather the screenshot, HTML export, handoff bundle, or design notes
5.  @DESIGN_HANDOFF_TO_MVS_PROMPT.md run
6.  Continue to @DESIGN_TOKENS_PROMPT.md run, @PAGE_SCOPING_CHECKLIST_PROMPT.md run, @NEW_PAGE_PROMPT.md run, or @NEW_CPT_PROMPT.md run
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

## Runtime Component Testing Or Troubleshooting

Use the standalone workflow when a real WordPress environment is required to reproduce, test, troubleshoot, fix, or retest behavior:

```text
C:\Users\Captain\Documents\AI Workflows\Task Workflows\WordPress\wordpress-component-testing-troubleshooting-debugging-workflow.md
```

Route only the focused behavior and evidence question. Keep Site Operations target confirmation and approval gates in force. Do not copy the standalone runtime procedure into this toolkit, and do not require a full runtime component pass for static presentation-only work; record the not-applicable rationale.

## Pre-Launch Order

| # | Prompt | What It Catches |
|---|--------|-----------------|
| 01 | Responsive QA | breakpoint coverage, overflow, stacking issues |
| 02 | Accessibility Review | semantics, alt text, focus states, WCAG issues |
| 03 | SEO Review | heading hierarchy, metadata, image and schema issues |
| 04 | Performance Review | image sizes, lazy loading, CSS efficiency |
| 05 | Cross-Browser QA | CSS support issues, fallback gaps, rendering risks |
| 05A | First-Party Security Review | first-party trust boundaries, input/output handling, authorization, data access, runtime handoffs |
| 06 | Final Checklist | 05A status, runtime disposition, forms, links, analytics, favicon, 404, redirects |

Prompt `06` remains last. If `05A` identifies behavior that static review cannot prove, complete the focused standalone runtime handoff before final prompt `06`.

## Common Tooling Workflow

| Workflow | Default Model | Notes |
|----------|---------------|-------|
| Session bootstrap | GPT-5.4 Mini or GPT-5.4 | Use the larger model for older or larger projects |
| Guided execution | GPT-5.4 Mini or GPT-5.4 | Best after session bootstrap when the user wants structured pacing, explicit progress tracking, and one approved task slice at a time |
| Session handoff | GPT-5.4 Mini or GPT-5.4 | Use when pausing work or switching to a fresh chat |
| Restore point | GPT-5.4 Mini or GPT-5.4 | Preview before rollback |
| Project bootstrap | GPT-5.4 | Best when planning and file generation happen together |
| New page / new CPT | GPT-5.4 then GPT-5.3 Codex | Explore first, then implement |
| 05A first-party security | GPT-5.4 then GPT-5.3 Codex | Phase 1 maps trust boundaries at High reasoning; Phase 2 applies only approved bounded fixes at Medium |
| Toolkit lessons audit | GPT-5.4 then GPT-5.3 Codex | Use when a working chat exposed reusable toolkit lessons or repeated mistakes |
| Launch reviews | GPT-5.4, Sonnet, or stronger judgment model as needed | Use deeper review for accessibility and final launch judgment |
| LocalWP reverse refresh | GPT-5.4 or GPT-5.4 Mini | Use the larger model when source/target context is incomplete or the refresh has unusual DB/upload risks |

Do not run the toolkit lessons audit for project-specific styling issues, content-entry mistakes, or isolated deployment problems unless they exposed a reusable gap in the toolkit itself.

## Copy-Paste Prompts

Start here:

```text
@START_HERE_MASTER_WORKFLOW.md run
```

Session bootstrap:

```text
@SESSION_BOOTSTRAP_PROMPT.md run
```

Guided execution:

```text
@GUIDED_EXECUTION_PROMPT.md run
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
@PAGE_SCOPING_CHECKLIST_PROMPT.md run
```

Build a page after scoping:

```text
@NEW_PAGE_PROMPT.md run
```

Convert a design handoff:

```text
@DESIGN_HANDOFF_TO_MVS_PROMPT.md run
```

Run launch sequence starting at step 01:

```text
@01-RESPONSIVE_QA_PROMPT.md run
```

Run the first-party security review after prompt 05:

```text
@05A-SECURITY_REVIEW_PROMPT.md run
```

Git operations:

```text
@GIT_OPERATIONS_PROMPT.md run
```

Refresh LocalWP from GridPane:

```text
@LOCALWP_REVERSE_REFRESH_PROMPT.md run
```

Review local DB changes only:

```text
@LOCALWP_REVERSE_REFRESH_PROMPT.md review local changes only
```

Toolkit lessons audit:

```text
@TOOLKIT_LESSONS_AUDIT_PROMPT.md run
```

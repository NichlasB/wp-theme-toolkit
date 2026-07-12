WP Theme Toolkit
================

Repository: https://github.com/NichlasB/wp-theme-toolkit
Latest tagged release: v0.2.0
License: GPLv2 or later

Purpose:
A structured toolkit of prompts, guides, and helper scripts for AI-assisted
WordPress site building with the Meta Views Stack.

Core stack:
- LocalWP
- Blocksy Pro + Blocksy child theme
- Meta Box AIO
- MB Views
- VS Code / Copilot / Codex / Cursor / Windsurf
- Element to LLM

Primary workflow:
1. Start with START_HERE_MASTER_WORKFLOW.md when the next workflow is not obvious
2. Read d1-setup/STACK_REFERENCE.md when routed into site setup or build work
3. Read d1-setup/LOCALWP_DATABASE_ACCESS_WORKFLOW.md before any LocalWP SQL or migration work
4. Create or update _project-context.md from d1-setup/PROJECT_CONTEXT_TEMPLATE.md
5. Create or update mvs-project-status.md from d1-setup/PROJECT_STATUS_TEMPLATE.md
6. Run d4-prompts/ds1-setup/PROJECT_BOOTSTRAP_PROMPT.md for new projects
7. Run d4-prompts/ds1-setup/SESSION_BOOTSTRAP_PROMPT.md for existing project resumes
8. Run d4-prompts/ds2-build/DESIGN_HANDOFF_TO_MVS_PROMPT.md for Claude Design, mockup, screenshot, or HTML handoffs
9. Run d4-prompts/ds1-setup/GUIDED_EXECUTION_PROMPT.md after bootstrap when you want slower pacing or explicit progress tracking
10. Run d4-prompts/ds1-setup/SESSION_HANDOFF_PROMPT.md before switching to a fresh chat
11. Run d4-prompts/ds7-maintenance/TOOLKIT_LESSONS_AUDIT_PROMPT.md against wp-theme-toolkit when a working chat reveals reusable toolkit lessons
12. Build with d4-prompts/ds2-build/
13. Review with d4-prompts/ds3-review/
14. Launch-check with d4-prompts/ds4-pre-launch/01 through 06
15. Run d4-prompts/ds5-deploy/GRIDPANE_DEPLOYMENT_PROMPT.md for the first LocalWP-to-GridPane launch
16. Run d4-prompts/ds5-deploy/POST_LAUNCH_GRIDPANE_UPDATE_PROMPT.md for incremental staging or production updates after launch
17. Run d4-prompts/ds5-deploy/LOCALWP_REVERSE_REFRESH_PROMPT.md when LocalWP needs current GridPane database content or missing uploads

Shared workflow note:
- d4-prompts/ds1-setup/SESSION_BOOTSTRAP_PROMPT.md is a local adapter around wp-workflow-toolkit/d4-prompts/ds1-session/SESSION_BOOTSTRAP_CORE_PROMPT.md
- d4-prompts/ds1-setup/GUIDED_EXECUTION_PROMPT.md, d4-prompts/ds1-setup/SESSION_HANDOFF_PROMPT.md, d4-prompts/ds1-setup/RESTORE_POINT_PROMPT.md, and d4-prompts/ds7-maintenance/TOOLKIT_LESSONS_AUDIT_PROMPT.md remain local entry points but are backed by canonical shared prompt bodies in wp-workflow-toolkit/

Shared workflow boundary:
- move a prompt into wp-workflow-toolkit only when the workflow intent, execution contract, and safety assumptions stay materially the same across both toolkits
- keep a prompt local when theme-specific targets, scan surfaces, release rules, or output formats would otherwise dominate the file
- update the shared canonical source first; update the local theme wrapper or adapter only when the theme-specific supplement changes

Repository structure:
- START_HERE_MASTER_WORKFLOW.md root router for new, stale, handoff, build, QA, deployment, and toolkit-improvement sessions
- d1-setup/      setup references and project schema
- d2-scripts/    restore-point helpers
- d3-guides/     design, Twig, Blocksy, workflow, and model guides
- d4-prompts/    setup, build, review, pre-launch, deploy, git, and maintenance prompts
- d5-examples/   example project context and build walkthrough

Important setup note:
- d1-setup/LOCALWP_DATABASE_ACCESS_WORKFLOW.md is the canonical LocalWP SQL access guide for fresh chats and migration work on Windows

Current release highlights:
- Add the start-here router, project-status recovery, guided execution, and toolkit lessons workflows
- Add Claude Design-to-MVS handoff and responsive typography-control guidance
- Add and harden LocalWP reverse refresh with local-data review, utf8mb4 protection, plugin reconciliation, and local-tool preservation
- Strengthen GridPane deployment, Meta Box local-file compatibility, MB Views data access, and Blocksy implementation guidance

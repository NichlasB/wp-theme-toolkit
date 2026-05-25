WP Theme Toolkit
================

Repository: local workspace repository
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
1. Read d1-setup/STACK_REFERENCE.md
2. Read d1-setup/LOCALWP_DATABASE_ACCESS_WORKFLOW.md before any LocalWP SQL or migration work
3. Create or update _project-context.md from d1-setup/PROJECT_CONTEXT_TEMPLATE.md
4. Run d4-prompts/ds1-setup/PROJECT_BOOTSTRAP_PROMPT.md for new projects
5. Run d4-prompts/ds1-setup/SESSION_BOOTSTRAP_PROMPT.md for new chats
6. Run d4-prompts/ds1-setup/GUIDED_EXECUTION_PROMPT.md after bootstrap when you want slower pacing or explicit progress tracking
7. Run d4-prompts/ds1-setup/SESSION_HANDOFF_PROMPT.md before switching to a fresh chat
8. Run d4-prompts/ds7-maintenance/TOOLKIT_LESSONS_AUDIT_PROMPT.md against wp-theme-toolkit when a working chat reveals reusable toolkit lessons
9. Build with d4-prompts/ds2-build/
10. Review with d4-prompts/ds3-review/
11. Launch-check with d4-prompts/ds4-pre-launch/01 through 06

Repository structure:
- d1-setup/      setup references and project schema
- d2-scripts/    restore-point helpers
- d3-guides/     design, Twig, Blocksy, workflow, and model guides
- d4-prompts/    setup, build, review, pre-launch, git, and maintenance prompts
- d5-examples/   example project context and build walkthrough

Important setup note:
- d1-setup/LOCALWP_DATABASE_ACCESS_WORKFLOW.md is the canonical LocalWP SQL access guide for fresh chats and migration work on Windows
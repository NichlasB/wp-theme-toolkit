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
2. Create or update _project-context.md from d1-setup/PROJECT_CONTEXT_TEMPLATE.md
3. Run d4-prompts/ds1-setup/PROJECT_BOOTSTRAP_PROMPT.md for new projects
4. Run d4-prompts/ds1-setup/SESSION_BOOTSTRAP_PROMPT.md for new chats
5. Run d4-prompts/ds1-setup/SESSION_HANDOFF_PROMPT.md before switching to a fresh chat
6. Build with d4-prompts/ds2-build/
7. Review with d4-prompts/ds3-review/
8. Launch-check with d4-prompts/ds4-pre-launch/01 through 06

Repository structure:
- d1-setup/      setup references and project schema
- d2-scripts/    restore-point helpers
- d3-guides/     design, Twig, Blocksy, workflow, and model guides
- d4-prompts/    setup, build, review, and pre-launch prompts
- d5-examples/   example project context and build walkthrough
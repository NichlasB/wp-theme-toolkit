# Changelog

All notable changes to this toolkit will be documented in this file.

The format is based on Keep a Changelog.

## [Unreleased]

### Added
- Added `d4-prompts/ds5-deploy/LOCALWP_REVERSE_REFRESH_PROMPT.md` for pulling GridPane staging or production database content and missing uploads back into the matching LocalWP site
- Added `d4-prompts/ds7-maintenance/TOOLKIT_LESSONS_AUDIT_PROMPT.md` for end-of-chat, approval-gated toolkit retrospectives based on real site-building sessions

### Changed
- Added a LocalWP plugin activation reconciliation step to the reverse refresh workflow so GridPane-only infrastructure plugins such as GridPane Nginx Helper and Rhubarb Group Redis Object Cache can be installed locally for parity but forced inactive after database import
- Added LocalWP-only tool preservation guidance to the reverse refresh workflow, including a Novamira/Novamira Pro allowlist for activation, settings, license state, user dismissals, and memory content
- Hardened the LocalWP reverse refresh workflow against emoji/data-loss encoding issues by requiring explicit `utf8mb4` import and search-replace sessions, byte-preserved SQL dump compatibility cleanup, and representative emoji validation
- Enhanced the LocalWP reverse refresh workflow with a read-only local database change review before replacement, plus a review-only mode for checking likely local-only content before pulling GridPane data down
- Updated README, readme.txt, task runner, IDE setup guide, workflow quick reference, project context reference, LocalWP database guide, Git workflow guide, structure reference, and Q&A docs for the LocalWP reverse refresh workflow
- Tightened the GridPane deployment workflow to lock the chosen migration method, require source-to-production plugin parity checks before DB import, and prefer archive-based Windows bulk transfers for large plugin and uploads payloads
- Tightened the post-launch GridPane update workflow to lock the chosen deploy path, require conditional plugin prechecks for DB/content refresh work, and make Windows archive-based bulk transfer validation more explicit
- Added child-theme bootstrap guidance that keeps `functions.php` as a lean loader and routes feature helpers into focused `inc/` files as projects grow
- Added the missing Meta Box local-file compatibility guidance so `.mbjson`-only projects also register `mbb_json_files` in `functions.php`; this prevents `File not found` and `No JSON available` field-group failures in future scaffolds
- Added a dedicated Meta Box local-file mode troubleshooting note to the toolkit Q&A reference, including the `.mbjson`-only failure mode, the `mbb_json_files` fix, and the meaning of `Sync available`
- Clarified MB Views Twig data-access rules across the Twig guide, stack reference, page-build prompt, and view-review prompt so normal custom fields are read from `post.*` or explicit `mb.rwmb_meta()` lookups instead of `mb.field_id`
- Corrected stale CPT prompt guidance so MB Views field access uses `post.*` or explicit `mb.rwmb_meta()` lookups instead of `mb.*` for normal single-context fields
- Added Blocksy full-width MB View guidance and review checks so replacement-content views use `alignfull` intentionally when they need to escape the constrained content shell
- Updated the child-theme scaffold examples so child CSS and JS assets use filemtime-based versioning during local development instead of only the static theme version header
- Added Blocksy troubleshooting guidance for parent-theme variables and higher-specificity selectors such as `body ::selection` and `#reply-title`
- Added design-system and Q&A guidance for sitewide interaction states so selection colors are set in the shared child-theme layer instead of page-level CSS
- Added CPT build guardrails around canonical registration source, migration flags, wp-admin visibility, and permalink flushing
- Added a runtime-validation note to the session bootstrap flow so expected CPT visibility, registration source, and permalink-flush risk are checked earlier in new sessions
- Declared `.mbjson` as the canonical tracked Meta Box schema format and added guidance to ignore duplicate `.json` export copies to prevent repo drift
- Extended `_TASK_RUNNER.md`, the workflow quick reference, structure reference, ignore rules, and repository docs to support the new toolkit-self lessons audit workflow and the new `ds7-maintenance/` prompt family

### Added
- Initial repository structure for `wp-theme-toolkit`
- Root operating files: README, readme.txt, task runner, project context reference, pre-launch checklist, and toolkit Q&A reference
- Core setup references for the Meta Views Stack, IDE setup, and `_project-context.md` schema
- Core guides for the design system, Twig patterns, Blocksy integration, workflow sequencing, model delegation, and Element to LLM iteration
- Initial prompt families for setup, build, review, and pre-launch workflows
- Example project-context and landing-page walkthrough files
- Restore-point helper scripts copied from the plugin toolkit and adapted for generic site or theme targets

## [0.1.0] - 2026-04-06

### Added
- First working draft of `wp-theme-toolkit`

# Changelog

All notable changes to this toolkit will be documented in this file.

The format is based on Keep a Changelog.

## [Unreleased]

### Changed
- Added the missing Meta Box local-file compatibility guidance so `.mbjson`-only projects also register `mbb_json_files` in `functions.php`; this prevents `File not found` and `No JSON available` field-group failures in future scaffolds
- Added a dedicated Meta Box local-file mode troubleshooting note to the toolkit Q&A reference, including the `.mbjson`-only failure mode, the `mbb_json_files` fix, and the meaning of `Sync available`
- Clarified MB Views Twig data-access rules across the Twig guide, stack reference, page-build prompt, and view-review prompt so normal custom fields are read from `post.*` or explicit `mb.rwmb_meta()` lookups instead of `mb.field_id`
- Corrected stale CPT prompt guidance so MB Views field access uses `post.*` or explicit `mb.rwmb_meta()` lookups instead of `mb.*` for normal single-context fields
- Added Blocksy full-width MB View guidance and review checks so replacement-content views use `alignfull` intentionally when they need to escape the constrained content shell
- Added CPT build guardrails around canonical registration source, migration flags, wp-admin visibility, and permalink flushing
- Added a runtime-validation note to the session bootstrap flow so expected CPT visibility, registration source, and permalink-flush risk are checked earlier in new sessions
- Declared `.mbjson` as the canonical tracked Meta Box schema format and added guidance to ignore duplicate `.json` export copies to prevent repo drift

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
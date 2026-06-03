# Toolkit Q&A Reference

Personal reference document for questions and answers about `wp-theme-toolkit`.

## How to use this file

- Record recurring workflow questions that you do not want to re-explain every session
- Keep entries short and operational
- Prefer concrete answers over discussion history

## Current Q&A

### Q: What is the primary target for this toolkit?
A: A site project or Blocksy child-theme root that uses the Meta Views Stack.

### Q: Where should MB View assignment decisions be stored?
A: In the placement map section inside `_project-context.md`.

### Q: Should live MB View changes also exist in files?
A: Yes. Keep local reference copies of Twig and CSS in the target repo even when the live view is pasted into WordPress admin.

### Q: What are the only supported responsive breakpoints in v1?
A: `900px` for tablet and `600px` for mobile.

### Q: Why do Meta Box field groups disappear or show `File not found` / `No JSON available` in a `.mbjson`-only project?
A: Meta Box Builder switches into local-file mode as soon as the project has an `mb-json/` directory, but by default it scans only `*.json`. If the project tracks only canonical `.mbjson` files, the field groups can disappear from the editor even though the schema files exist in Git. The fix is to keep `.mbjson` as the source of truth and expose those files through `mbb_json_files` in `functions.php`:

```php
add_filter( 'mbb_json_files', static function ( $files ) {
	$mbjson_files = glob( get_stylesheet_directory() . '/mb-json/*.mbjson' );

	if ( false === $mbjson_files || empty( $mbjson_files ) ) {
		return $files;
	}

	return array_values( array_unique( array_merge( $files, $mbjson_files ) ) );
} );
```

Quick diagnosis checklist:
- confirm the project has an `mb-json/` directory
- confirm the tracked schema files end in `.mbjson`
- confirm the field groups disappear in the editor or the Meta Box list shows `File not found` / `No JSON available`
- confirm `functions.php` does or does not contain the `mbb_json_files` bridge

Do not restore duplicate `.json` twins as the long-term fix unless the project intentionally wants Meta Box's default `.json` workflow.

### Q: What does `Sync available` mean after the fields come back?
A: Meta Box can now see both the local schema file and the database field group, and it believes they differ. In a file-first workflow, review the diff and sync intentionally. The important part is that the field group is loading again; `Sync available` is a state to review, not the original failure mode.

### Q: Why does a child-theme CSS change sometimes look ignored even when the file is loaded?
A: Check three things in order:

1. Inspect computed styles in DevTools. Blocksy or WordPress may be driving the surface through a shared variable or a stronger selector such as `body ::selection` or `#reply-title`.
2. If the parent theme is styling through variables, override those variables in the shared child-theme layer such as `style.css` or another globally loaded stylesheet. If the parent theme is using a more specific selector, match or exceed that specificity in the child theme.
3. Confirm child CSS and JS assets are versioned by file modification time instead of only the static theme version header, otherwise the browser can keep serving stale files during local iteration.

### Q: How do the shared workflow prompts work after consolidation?
A: Keep using the local prompt filenames in `wp-theme-toolkit`. `SESSION_BOOTSTRAP_PROMPT.md` is now a local adapter around the shared bootstrap core in `wp-workflow-toolkit/d4-prompts/ds1-session/SESSION_BOOTSTRAP_CORE_PROMPT.md`. `GUIDED_EXECUTION_PROMPT.md`, `SESSION_HANDOFF_PROMPT.md`, `RESTORE_POINT_PROMPT.md`, and `TOOLKIT_LESSONS_AUDIT_PROMPT.md` are local wrappers backed by canonical shared prompt bodies there. Update the shared source first; touch the local theme file only when the theme-specific notes, scan surface, output format, or safety rules change.

### Q: When should I run the LocalWP reverse refresh workflow?
A: Run `@LOCALWP_REVERSE_REFRESH_PROMPT.md` when an existing LocalWP site needs current GridPane staging or production database content, settings, or media before new development, QA, troubleshooting, or post-launch refinement.

The workflow is intentionally content-facing:
- it can replace the LocalWP database after creating a local DB backup
- it copies missing files from remote `wp-content/uploads/` by default
- it does not sync themes, plugins, WordPress core, workflow notes, or code files

Uploads are additive by default because local media may include temporary test files, local-only QA artifacts, or work-in-progress assets that should not be deleted or overwritten during a content refresh. Overwriting uploads requires explicit approval, and deletion is still outside the default workflow.

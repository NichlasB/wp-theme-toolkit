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
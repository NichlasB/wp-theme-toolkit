<!-- Task Type: Two-Phase | See _TASK_RUNNER.md for execution instructions -->

# 05A First-Party Security Review Prompt

Run this after `05-CROSS_BROWSER_QA_PROMPT.md` and before `06-FINAL_CHECKLIST_PROMPT.md`.

## Purpose

Perform a bounded security review of the first-party executable behavior in a Meta Views Stack site project or WordPress child theme before launch.

This workflow reviews the code and configuration the project owns: custom PHP, JavaScript, Twig, forms, handlers, queries, file operations, redirects, REST/AJAX behavior, external requests, and custom data access. It identifies credible security defects, produces an approval-gated remediation plan, applies approved fixes in Phase 2, and reruns affected checks.

This is not a whole-WordPress vulnerability audit. It does not broadly audit WordPress core, the Blocksy parent theme, Meta Box, MB Views, or other third-party plugins and services unless the user explicitly adds a specific component or integration behavior to scope.

`06-FINAL_CHECKLIST_PROMPT.md` remains the final operational pre-launch gate.

## Scope And Ownership

This workflow owns:

- first-party security-boundary inventory;
- trust-boundary and data-flow analysis;
- static review of first-party PHP, JavaScript, Twig, and relevant configuration;
- security findings and severity classification;
- an approval-gated remediation plan;
- approved first-party fixes and affected static checks;
- exact handoffs for runtime verification that static review cannot prove.

This workflow does not replace:

- `VIEW_REVIEW_PROMPT.md`, which remains the focused markup, design-system, responsive, data-access-pattern, and placement review for changed views;
- the broader pre-launch prompts `01` through `05`;
- `06-FINAL_CHECKLIST_PROMPT.md`, which remains the final operational gate;
- `Task Workflows/WordPress/wordpress-component-testing-troubleshooting-debugging-workflow.md`, which owns testing, troubleshooting, evidence collection, fixes, and retesting in a confirmed WordPress runtime;
- a penetration test, dependency-vulnerability service, host-security audit, or third-party source-code audit.

## Use When

- The child theme or site project contains custom PHP hooks, handlers, registrations, shortcodes, queries, file operations, or configuration.
- First-party JavaScript reads untrusted data, manipulates the DOM, stores data, or sends requests.
- Twig or another rendering layer outputs custom fields, request-derived values, URLs, HTML, shortcode results, or integration data.
- The project contains forms, AJAX actions, REST routes, redirects, webhooks, cron behavior, external HTTP calls, imports, exports, or uploads.
- Custom code reads or mutates Meta Box fields, WordPress options, post meta, user meta, taxonomy data, or other records.
- A security-sensitive fix was made and the pre-launch security evidence needs to be refreshed.

## Do Not Use When

- The project contains only static presentation files with no meaningful first-party security boundary. Record a proportionate Phase 1 `No updates needed` result and identify any runtime or operational checks that remain.
- The goal is to audit WordPress core, the Blocksy parent theme, Meta Box, MB Views, or another third-party plugin as a product.
- The goal is to scan a host, probe a live site, exploit a vulnerability, perform load testing, or run destructive security tests.
- The only goal is to reproduce or troubleshoot behavior in wp-admin or on the frontend. Use the standalone WordPress component-testing workflow.
- The task is a general privacy, legal-compliance, infrastructure, DNS, TLS, or server-hardening review with no first-party child-theme code question.

## Required Context

Before Phase 1:

1. Confirm the target project using `_TASK_RUNNER.md`.
2. Read:
   - `_project-context.md`;
   - `mvs-project-status.md` when present;
   - `d1-setup/STACK_REFERENCE.md`;
   - `d3-guides/TWIG_PATTERNS_GUIDE.md`;
   - directly relevant placement-map entries and local MB View reference files.
3. Inspect the smallest useful set of:
   - `functions.php`;
   - first-party files under `inc/`, `src/`, `assets/`, `js/`, `views/`, `templates/`, or equivalent directories;
   - first-party `.mbjson` and other registration/configuration artifacts;
   - first-party package or dependency manifests when bundled runtime code matters;
   - existing lint, test, build, or static-analysis configuration;
   - Git status and the current diff.
4. Identify which Twig and CSS files are local reference copies of database-backed MB Views and whether the project context says they match the current WordPress state.
5. Note whether a restore point or equivalent version-control safety exists before any Phase 2 edit.

Do not require unrelated project files merely to make the inventory look complete.

## Default Scope Boundary

Include by default:

- first-party child-theme and site-project PHP;
- first-party browser JavaScript;
- first-party Twig, HTML fragments, and templates;
- project-owned `.mbjson`, registration, routing, and integration configuration;
- custom forms and their handlers;
- custom AJAX, REST, admin-post, webhook, cron, and redirect logic;
- first-party database queries and data mutations;
- first-party file, upload, import, export, and path handling;
- first-party calls to WordPress, Meta Box, MB Views, Blocksy, and external-service APIs;
- first-party logging, error handling, debug code, and secret handling.

Exclude by default:

- WordPress core source;
- parent-theme source;
- third-party plugin or library source;
- hosting, operating-system, database-server, DNS, TLS, firewall, and network configuration;
- unrelated content, media, and administrator-authored copy;
- speculative vulnerabilities with no first-party call path or credible project impact.

If a third-party component appears to be the root cause:

1. identify the first-party integration point;
2. record the evidence and affected behavior;
3. recommend the appropriate vendor, dependency, runtime, or infrastructure follow-up;
4. do not silently broaden this review into a vendor-code audit.

## Security Principles

Apply these rules throughout both phases:

- Trace data from source to authorization decision, mutation, query, file operation, redirect, request, log, and output sink.
- Treat validation, sanitization, authorization, ownership, intent verification, and output escaping as different controls.
- A nonce verifies intent and request origin; it does not replace capability or ownership checks.
- Sanitization does not replace contextual escaping.
- A UI restriction does not protect a server-side handler.
- A Blocksy placement condition or MB View location rule is not an authorization boundary.
- A Meta Box field definition does not make stored field data trusted.
- Do not assume Twig autoescaping, shortcode output, helper functions, or plugin APIs are safe without confirming the actual output context and project behavior.
- Prefer WordPress APIs and the smallest behavior-preserving fix.
- Do not hide a vulnerability by suppressing errors, removing diagnostics, weakening a check, or changing expected behavior without an approved product decision.

## Safety Rules

- Phase 1 is read-only and must not modify source, configuration, WordPress content, MB Views, the database, or generated artifacts.
- Avoid Phase 1 commands that create caches, reports, lockfile changes, build output, or other repository artifacts unless output can be redirected outside the target.
- Phase 2 requires the completed Phase 1 plan and the approval required by `_TASK_RUNNER.md`.
- Do not run exploit payloads, destructive probes, credential attacks, resource exhaustion, state corruption, or broad fuzzing against a live site.
- Do not put real secrets, customer data, authentication cookies, private payloads, or production credentials into tests or reports.
- Do not modify database-backed MB Views, Blocksy settings, WordPress content, LocalWP, staging, or live environments merely because a source finding suggests runtime verification.
- Before any LocalWP, staging, live-site, database, SSH, or deployment action, follow:
  - `C:\Users\Captain\Documents\AI Workflows\Site Operations\wordpress-site-operations.md`;
  - `C:\Users\Captain\Documents\AI Workflows\Site Operations\wordpress-sites.md`.
- Route environment-backed testing to:
  - `C:\Users\Captain\Documents\AI Workflows\Task Workflows\WordPress\wordpress-component-testing-troubleshooting-debugging-workflow.md`.
- Runtime handoff does not authorize site access or writes. The standalone workflow's target confirmation and approval gates still apply.

---

## Phase 1: Read-Only Security Discovery And Remediation Plan

Do not modify files or WordPress state during Phase 1.

### 1. Confirm Scope And First-Party Ownership

Record:

- target project and root;
- child-theme or site-project identity;
- first-party directories and files;
- database-backed artifacts represented only by local reference files;
- integrations touched;
- excluded core, parent-theme, third-party, infrastructure, and content surfaces;
- source or runtime evidence that is unavailable;
- current Git status and existing user changes.

Classify the project:

- `Executable first-party behavior present`;
- `Limited executable behavior`;
- `Presentation-only or no meaningful security boundary`;
- `Scope blocked or unclear`.

Do not manufacture findings or security work for a presentation-only project.

### 2. Build The Security Surface Inventory

Inventory applicable surfaces:

| Surface | Entry points | Trust boundary | Sensitive action or data | First-party files | Runtime evidence needed |
|---|---|---|---|---|---|
| PHP hooks and handlers |  |  |  |  |  |
| Forms and submissions |  |  |  |  |  |
| AJAX and REST |  |  |  |  |  |
| Twig and rendered output |  |  |  |  |  |
| JavaScript and DOM |  |  |  |  |  |
| Database and metadata |  |  |  |  |  |
| Files, imports, and exports |  |  |  |  |  |
| Redirects and external requests |  |  |  |  |  |
| Secrets, logs, and errors |  |  |  |  |  |
| Meta Box, MB Views, and Blocksy integration |  |  |  |  |  |

For every entry point, identify:

- who can reach it;
- which request, stored, remote, or administrator-authored values it consumes;
- which capability, ownership, intent, and state assumptions it makes;
- what it reads, changes, exposes, sends, renders, logs, or redirects to;
- what static review can prove;
- what needs a confirmed WordPress runtime.

### 3. Review PHP Input Handling And Authorization

Inspect applicable first-party PHP for:

#### Input sources

- `$_GET`, `$_POST`, `$_REQUEST`, `$_FILES`, `$_COOKIE`, and server headers;
- REST request parameters and JSON bodies;
- AJAX and admin-post payloads;
- shortcode attributes, block attributes, query variables, and URL parameters;
- webhook bodies and signatures;
- options, post meta, user meta, term meta, and imported data;
- remote API responses and cached/transient values.

#### Validation and normalization

- expected type, shape, enum, range, format, length, and required fields;
- identifier validation before record access;
- allowlists for actions, sort keys, status values, templates, paths, and redirect targets;
- rejection of unexpected arrays, objects, nested values, and duplicate parameters;
- validation before side effects, not only before display.

#### Sanitization

- sanitization suited to the data contract;
- no reliance on generic text sanitization for structured data, HTML, URLs, filenames, SQL identifiers, or JSON;
- normalization that does not silently turn invalid input into a privileged or destructive default.

#### Authentication, capabilities, and ownership

- appropriate capability checks on every privileged server-side action;
- resource ownership checks where users can access or change their own records;
- no role-name assumptions where a capability is required;
- no trust in hidden fields, disabled controls, client-side state, or admin-menu visibility;
- explicit authorization callbacks for custom REST routes;
- deliberate treatment of `wp_ajax_nopriv_*` and public endpoints.

#### Nonces and replay

- nonce verification on state-changing browser-originated actions;
- capability and ownership checks in addition to nonces;
- correct action and field names;
- no nonce exposure in public caches or logs;
- webhook signatures, timestamps, replay windows, and idempotency where nonces do not apply.

### 4. Review Queries, Data Access, And Mutations

Check:

- WordPress APIs are used where they provide safer behavior;
- `$wpdb->prepare()` is used for untrusted values;
- dynamic table, column, direction, status, and order-by values use explicit allowlists;
- `LIKE` values use `$wpdb->esc_like()` before preparation;
- arrays used in `IN` clauses have validated types and correctly generated placeholders;
- user-controlled values cannot select arbitrary records, post types, meta keys, or users;
- reads enforce visibility, capability, ownership, and status requirements;
- writes validate the target record and expected current state;
- bulk, delete, update, import, and migration actions have bounded scope and failure handling;
- error output does not expose query text, schema, credentials, or private data.

For Meta Box and WordPress metadata:

- field IDs and object IDs influenced by requests are allowlisted or validated;
- private or administrative metadata is not exposed merely because a field API can retrieve it;
- user-meta and post-meta access respects ownership and capability boundaries;
- REST exposure or custom serialization does not leak fields unintentionally;
- repeaters, groups, and relationship data are validated as structured data before mutation.

### 5. Review Twig, MB Views, And Rendered Output

Trace first-party values into their exact output contexts:

- HTML text;
- HTML attributes;
- URLs and link destinations;
- inline or data-driven JavaScript;
- JSON embedded in markup;
- CSS values and style attributes;
- shortcode or helper output;
- raw HTML or rich-text fields.

Check:

- output uses context-appropriate escaping at the final sink;
- the project does not assume that stored administrator data is always safe;
- `|raw`, raw HTML, helper calls, and shortcode rendering are justified and constrained;
- URL schemes and destinations are safe;
- attribute construction cannot be broken by quotes or control characters;
- JSON is encoded for its embedding context;
- untrusted values do not become function names, template names, field IDs, query arguments, or arbitrary shortcodes;
- fallback output does not disclose internal errors or sensitive values.

Meta Views Stack rules:

- `post.*` and `mb.rwmb_meta()` usage is reviewed as data access, not treated as automatic authorization or escaping;
- `mb.*` PHP-function proxy calls are inventoried where first-party Twig can invoke functions or perform custom lookups;
- `function('do_shortcode', ...)` does not execute an arbitrary field-controlled shortcode unless that behavior is intentionally constrained;
- custom queries inside or behind MB Views validate all request-influenced arguments;
- local Twig reference files are not claimed to prove the database-backed MB View matches runtime state;
- Blocksy Content Block placement and MB View location rules are not treated as access control.

### 6. Review JavaScript And Browser-Side Data Handling

Check applicable first-party JavaScript for:

- unsafe DOM sinks such as `innerHTML`, `outerHTML`, `insertAdjacentHTML`, string-built event handlers, and unsafe script or URL assignment;
- selector, attribute, and template construction from untrusted values;
- DOM-based XSS through query strings, hashes, storage, `postMessage`, API responses, or dataset values;
- missing origin and message-shape checks for `postMessage`;
- sensitive data in localized script objects, HTML, data attributes, logs, local storage, or session storage;
- nonce and endpoint exposure beyond what the action requires;
- state-changing requests without server-side authorization and intent verification;
- redirect or navigation targets controlled by request or remote data;
- credentials or privileged tokens stored in browser-accessible locations;
- error handling that reveals sensitive response bodies or internal details.

Client-side checks never replace server-side validation and authorization.

### 7. Review Forms, AJAX, REST, And Other Handlers

For every first-party handler, verify:

- method and content type are enforced when relevant;
- parameters are validated before use;
- authentication requirements are explicit;
- capability and ownership checks match the affected resource;
- nonce, signature, timestamp, replay, or idempotency protection matches the channel;
- rate or abuse controls are considered for public expensive actions;
- responses expose only required fields;
- errors use safe status codes and messages;
- CORS behavior is deliberate;
- state-changing GET behavior is absent;
- redirects after handling are validated and terminate safely;
- duplicate submission and partial failure do not create unauthorized or corrupt state.

### 8. Review Files, Paths, Uploads, Imports, And Exports

Check:

- paths are derived from trusted roots and normalized before comparison;
- user input cannot traverse directories or select arbitrary files;
- filenames are sanitized without relying on the name alone for type safety;
- extension, MIME, content, size, and count limits are appropriate;
- uploaded or generated files cannot execute unexpectedly;
- temporary files use safe unique locations and are cleaned up;
- archive extraction prevents path traversal and unsafe links;
- read, write, delete, include, and download operations enforce capability and ownership;
- export/download responses do not disclose private records or filesystem paths;
- imports validate structure and avoid unsafe deserialization;
- errors do not reveal absolute paths, server layout, or secret values.

### 9. Review Redirects, External Requests, And Integrations

Check:

- redirects use safe destinations and appropriate WordPress helpers;
- arbitrary user-controlled redirect targets and unsafe schemes are rejected;
- server-side HTTP destinations cannot become SSRF primitives;
- allowed hosts, schemes, ports, and paths are constrained where input influences a request;
- timeouts, redirect limits, response sizes, and error handling are bounded;
- TLS verification is not disabled;
- credentials are not placed in URLs, logs, frontend code, or committed files;
- webhook secrets and API tokens are loaded from an approved secret source;
- remote responses are treated as untrusted and validated before storage or rendering;
- retries and callbacks do not duplicate sensitive side effects.

Do not contact production services or send real external side effects during this review.

### 10. Review Secrets, Logging, Errors, And Debug Remnants

Search first-party scope for:

- hardcoded credentials, tokens, passwords, private endpoints, or signing secrets;
- committed environment files or secret-bearing configuration;
- `var_dump`, `print_r`, `dd`, debug echoes, verbose exception output, and sensitive `console.log`;
- commented-out authorization, nonce, validation, or escaping controls;
- TODO/FIXME notes indicating unfinished security work;
- logs containing tokens, cookies, personal data, request bodies, query text, filesystem paths, or remote responses;
- user-facing errors that disclose stack traces, SQL, paths, secrets, object contents, or internal identifiers;
- debug behavior that can be enabled by an untrusted request or left active in production;
- predictable temporary, export, or cache files containing sensitive data.

Do not remove useful diagnostics merely to hide a finding. Make logging safe and proportionate.

### 11. Classify Findings

Use:

- `critical` — exploitable authorization bypass, privilege escalation, arbitrary code/file action, credential exposure, destructive unauthenticated action, broad sensitive-data exposure, or a defect likely to cause severe production harm;
- `high` — serious stored/reflected/DOM XSS, SQL injection, SSRF, broken ownership enforcement, unsafe upload/download, missing authorization on a sensitive action, or meaningful private-data exposure;
- `medium` — bounded information disclosure, incomplete validation or nonce handling with constrained impact, unsafe redirect, weak external-request boundary, or security-relevant failure handling requiring correction;
- `low` — defense-in-depth gap, debug remnant without sensitive output, overly broad but non-exploitable data exposure, or maintainability issue likely to become a security risk;
- `informational` — evidence, assumption, or hardening opportunity that is not a confirmed defect.

For every finding, record:

```text
ID:
Severity:
Confidence: confirmed / likely / needs runtime evidence
First-party file and line:
Entry point:
Data source:
Trust boundary:
Sensitive operation or sink:
Missing or ineffective control:
Reproduction or proof:
Impact:
Scope exclusions considered:
Recommended fix:
Affected checks:
Runtime verification required:
```

Do not inflate severity based only on a dangerous function name. Trace reachability, control, authorization, context, and impact.

### 12. Identify Runtime Verification Handoffs

Static review cannot prove:

- actual WordPress route or hook registration;
- active roles, capabilities, ownership, and nonce behavior;
- current database-backed MB View content and assignments;
- Blocksy Content Block conditions;
- rendered escaping and DOM behavior in the real page;
- AJAX, REST, form, redirect, upload, and external-request behavior in the active environment;
- current logging, error display, plugin configuration, or integration state.

For each case requiring runtime evidence, record:

- exact behavior to test;
- site/environment requirements;
- required user role or ownership state;
- safe test data;
- expected request and response;
- logs or browser evidence to inspect;
- whether the test is safe for LocalWP, staging, or read-only live inspection;
- the standalone component-workflow handoff.

Do not copy the standalone workflow's runtime instructions into this prompt.

### 13. Build The Phase 2 Plan

Order work by:

1. critical and high authorization, injection, code/file, secret, and sensitive-data risks;
2. stored or persistent risks;
3. public and low-privilege entry points;
4. destructive or money/data-affecting actions;
5. medium validation, redirect, request, and disclosure issues;
6. low-risk hardening and debug cleanup.

For each approved candidate, specify:

- finding ID;
- exact files;
- smallest behavior-preserving fix;
- compatibility and data considerations;
- static checks;
- runtime handoff;
- rollback;
- whether the fix invalidates pre-launch prompts `01` through `05`;
- whether another Phase 1 decision is required.

### Phase 1 Output Format

#### Executive Summary

```text
Target project:
Project classification:
First-party files reviewed:
Executable surfaces:
Critical findings:
High findings:
Medium findings:
Low findings:
Informational findings:
Runtime verification handoffs:
Excluded third-party/core surfaces:
Environment or source blockers:
Phase 2 recommendation: Proceed / No updates needed / Blocked
```

#### Surface Inventory

| Surface | Entry points | Trust boundary | Sensitive action/data | Files | Runtime evidence |
|---|---|---|---|---|---|

#### Findings

Use the finding format above for every issue.

#### Runtime Handoff Matrix

| Finding or behavior | Environment | Role/state | Safe steps | Evidence required | Standalone workflow |
|---|---|---|---|---|---|

#### Ordered Phase 2 Plan

```text
1. [Finding ID] [change]
   Files:
   Security control:
   Compatibility/data impact:
   Static checks:
   Runtime handoff:
   Earlier pre-launch checks invalidated:
   Rollback:
```

If no changes are justified, state why the project's first-party executable behavior is already proportionate or why no meaningful security boundary exists. Do not use `No updates needed` to imply that runtime, vendor, infrastructure, or final operational checks have passed.

<!-- PHASE 1 END -->

---

## Phase 2: Approved Security Fixes And Verification

Phase 2 requires:

- the completed Phase 1 inventory, findings, and plan;
- user approval under `_TASK_RUNNER.md`;
- a current restore point or equivalent version-control safety;
- confirmation that the target and Git state have not materially changed.

If scope, files, WordPress state, or project requirements changed materially after Phase 1, refresh the affected analysis before editing.

### 1. Reconfirm Scope And Baseline

Before changes:

- confirm the target root;
- review current Git status and diff;
- preserve unrelated user changes;
- confirm first-party versus excluded surfaces;
- confirm approved findings and files;
- identify safe existing lint, test, build, or syntax commands;
- confirm whether any runtime action has separate target approval.

Do not absorb unrelated new findings into Phase 2 without reporting them and obtaining approval when they materially expand the plan.

### 2. Apply The Smallest Root-Cause Fix

For each approved finding:

1. preserve the intended behavior and compatibility contract;
2. correct the control at the server-side or final output boundary where it belongs;
3. add validation, authorization, ownership, nonce/signature, preparation, safe path, safe redirect, or contextual escaping as required;
4. avoid broad refactors unless the approved finding cannot be fixed safely without one;
5. keep parent-theme, plugin, and vendor code unchanged unless explicitly approved and brought into scope;
6. update local Twig references when approved source changes affect the corresponding runtime view;
7. record any database-backed MB View or WordPress change still required as a runtime handoff rather than claiming it was applied.

Do not:

- remove a capability or ownership check to restore functionality;
- weaken validation or escaping to preserve malformed input;
- trust a nonce as authorization;
- suppress errors instead of correcting disclosure;
- hardcode secrets;
- disable TLS verification;
- add unsafe bypasses for administrators;
- claim a static source fix changed database-backed runtime state.

### 3. Verify Affected Static Behavior

Run the smallest applicable existing checks:

- PHP syntax checks for changed PHP;
- configured coding-standard or static-analysis commands;
- configured JavaScript lint, test, and build commands;
- configured template/Twig checks;
- targeted searches for the vulnerable pattern and related call sites;
- existing automated regression tests when present;
- diff review for secret, debug, and generated-artifact leakage.

Do not install broad new tooling merely to complete this prompt. Report missing coverage.

For a confirmed defect:

- add or update permanent automated regression protection when an appropriate harness already exists and the approved plan includes it;
- otherwise record the owning-project follow-up, impractical-to-automate rationale, or tooling blocker;
- do not manufacture ceremonial tests for presentation-only behavior.

### 4. Perform Or Record Runtime Handoffs

When runtime verification is required:

1. preserve the finding bundle and exact test matrix from Phase 1;
2. use `Task Workflows/WordPress/wordpress-component-testing-troubleshooting-debugging-workflow.md`;
3. follow Site Operations for the confirmed target and mode;
4. obtain any required approval for LocalWP data creation, staging writes, live diagnostics, or live changes;
5. return the runtime result to this security review.

If runtime verification is not authorized or available:

- mark it `Blocked` or `Deferred`;
- state what remains unproven;
- do not call the finding fully verified.

### 5. Rerun Invalidated Pre-Launch Checks

If a security fix changes:

- markup or Twig output, rerun the affected accessibility, responsive, SEO, and cross-browser checks;
- JavaScript behavior, rerun affected accessibility, performance, cross-browser, and runtime checks;
- forms, routes, redirects, data access, or handlers, rerun the affected runtime component matrix;
- assets or builds, rerun the configured build and relevant performance checks;
- project context, placement, or local/runtime sync, update and verify the affected references.

After fixes and affected reruns:

1. rerun the relevant 05A security checks;
2. resolve or explicitly block every approved finding;
3. run `06-FINAL_CHECKLIST_PROMPT.md` last.

### 6. Determine Final Status

Use exactly one:

- `Clean` — no unresolved confirmed finding remains in scope; approved fixes and affected static checks pass; required runtime evidence is complete.
- `No updates needed` — Phase 1 established that no first-party security change was justified; remaining runtime and operational checks are explicitly identified.
- `Partially verified` — source fixes or checks pass, but runtime, environment, integration, or tooling evidence remains unavailable.
- `Blocked` — an unresolved defect, missing decision, unsafe verification path, environment, or required dependency prevents credible completion.

Do not use `Clean` to claim that WordPress core, the parent theme, third-party plugins, hosting, or the entire live site is secure.

### Phase 2 Output Format

#### Executive Summary

```text
Target project:
Final status: Clean / No updates needed / Partially verified / Blocked
First-party files reviewed:
Files created:
Files modified:
Findings fixed:
Findings remaining:
Static checks:
Runtime verification:
Earlier pre-launch checks rerun:
Excluded core/parent-theme/third-party scope:
Final 05A rerun:
06 final operational checklist still required: Yes
```

#### Changes By Finding

```text
Finding ID:
Severity:
Files changed:
Root-cause fix:
Security control:
Compatibility/data impact:
Static verification:
Automated regression disposition:
Runtime verification:
Result: Resolved / Partially verified / Deferred / Blocked
```

#### Commands And Checks

| Command or check | Scope | Result | Notes |
|---|---|---|---|

#### Runtime Handoffs

| Finding or behavior | Target/mode | Standalone workflow status | Evidence | Remaining blocker |
|---|---|---|---|---|

#### Remaining Findings And Decisions

```text
Finding:
Reason unresolved:
Risk:
Required owner or decision:
Exact next step:
```

#### Final Verification

```text
Git status:
Generated artifacts:
Secret/debug leakage check:
Affected pre-launch reruns:
Runtime coverage gaps:
Final 05A status:
Next required prompt: 06-FINAL_CHECKLIST_PROMPT.md
```

Update `PRE_LAUNCH_CHECKLIST.md` according to `_TASK_RUNNER.md` after successful Phase 2, or after the runner's terminal Phase 1 exception when the result explicitly states `Phase 2 recommendation: No updates needed`, records the proportionate scope and rationale, and has no approved fixes awaiting execution. Do not mark this workflow complete for an ordinary Phase 1 handoff awaiting Phase 2, or for a failed, paused, partially verified, or blocked run.

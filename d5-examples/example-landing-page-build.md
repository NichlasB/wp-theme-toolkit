# Example Landing Page Build

This walkthrough shows a typical first project flow using `wp-theme-toolkit`.

## 1. Local Setup

1. Create a new LocalWP site
2. Install WordPress
3. Install Blocksy Pro and activate it
4. Install Meta Box AIO
5. Create the Blocksy child theme scaffold
6. Add the site project and `wp-theme-toolkit` to the same IDE workspace

## 2. Bootstrap The Project

1. Read `d1-setup/STACK_REFERENCE.md`
2. Run `@PROJECT_BOOTSTRAP_PROMPT.md run`
3. Review the generated `_project-context.md`
4. Confirm the spacing, type, and palette mapping

## 3. Set The Brand Direction

Example brief:

```text
Business type: design studio
Vibe words: calm, premium, direct
Palette direction: one accent
```

Then run:

```text
@DESIGN_TOKENS_PROMPT.md run
```

Update the Blocksy palette so its six slots match the documented roles in `_project-context.md`.

## 4. Build The Homepage Hero

1. Define the hero goals in `_project-context.md`
2. Create or update a `home-hero.mbjson` schema if field-driven content is needed
3. Run `@NEW_PAGE_PROMPT.md run`
4. Save the local reference files under `views/sections/`
5. Paste the Twig and CSS into MB Views
6. Place the hero with a Blocksy Content Block if it belongs above the normal content flow
7. Record the assignment in the placement map

## 5. Refine With Element To LLM

1. Open the local homepage
2. Capture the hero section with Element to LLM
3. Paste the capture into chat with a concrete refinement goal
4. Apply the revised Twig and CSS
5. Update the local reference copy in `views/`

## 6. Add The Team Members CPT

1. Run `@NEW_CPT_PROMPT.md run`
2. Create or update `inc/cpt.php`
3. Save the generated `.mbjson` in `mb-json/`
4. Create the single and archive views
5. Paste them into MB Views and assign the live rules
6. Record both assignments in the placement map

## 7. Review The Work

1. Run `@VIEW_REVIEW_PROMPT.md run`
2. Run `@CSS_CONSISTENCY_AUDIT_PROMPT.md run`
3. Run `@DESIGN_SYSTEM_COMPLIANCE_PROMPT.md run`

## 8. Pre-Launch Sequence

Run these in order:

1. `@01-RESPONSIVE_QA_PROMPT.md run`
2. `@02-ACCESSIBILITY_REVIEW_PROMPT.md run`
3. `@03-SEO_REVIEW_PROMPT.md run`
4. `@04-PERFORMANCE_REVIEW_PROMPT.md run`
5. `@05-CROSS_BROWSER_QA_PROMPT.md run`
6. `@06-FINAL_CHECKLIST_PROMPT.md run`

## 9. Go Live Preparation

Before launch, confirm:
- live MB View and Blocksy assignments match the placement map
- forms work
- analytics is connected
- the 404 page is styled
- redirects are documented
- Git is clean and the local reference copies match the live templates
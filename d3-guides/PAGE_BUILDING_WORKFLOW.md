# Page Building Workflow

This guide defines the default Meta Views Stack workflow for standard website pages that are not custom post types or sitewide global sections.

For the shortest day-to-day version, read `d3-guides/PAGE_DECISION_TREE_CHEAT_SHEET.md` first.

Use it for pages such as:
- About
- Contact
- Services
- Pricing
- FAQ
- landing pages
- campaign pages

## Core Decision Rule

Choose the smallest content model that still fits the page.

Default order:
1. Build the page as one page-level MB View
2. Split out only the sections that need reuse or special placement
3. Create a CPT only when the content is truly repeatable across many entries

That means most standard pages should start as:
- one WordPress page
- one page-targeted field group when structured fields are needed
- one MB View for the page body
- one local Twig reference file
- one local CSS reference file or paired CSS reference notes

Do not start by turning every section into its own MB View. That increases admin setup, placement complexity, and maintenance cost without adding value for page-unique sections.

## Default Page Pattern

For a normal multi-section page, the default pattern is:
- one field group
- one MB View
- multiple `<section>` blocks inside the same Twig template

Use section-prefixed field names so the editor stays readable and the template scans cleanly.

Examples:
- `hero_heading`
- `hero_body`
- `intro_image`
- `services_heading`
- `services_items`
- `pricing_tiers`
- `faq_items`
- `contact_form_shortcode`

Recommended local file pattern:
- `mb-json/page_about.mbjson`
- `views/single/page-about.twig`
- `views/single/page-about.css`
- `views/reference/about-page-spec.md`

Recommended live MB View naming:
- `view-page-about`
- `view-page-contact`
- `view-page-services`
- `view-page-pricing`

## When To Keep Content Static

Do not create fields just because the page exists.

Keep content static in the Twig when:
- the copy is stable and unlikely to change often
- the layout is highly custom but the content is simple
- the section has little editorial value in wp-admin
- the content is better maintained directly in version-controlled files

Typical static examples:
- decorative dividers
- trust badges with fixed labels
- short supporting copy that rarely changes
- layout-only wrappers

## When To Add Page Fields

Use page-targeted Meta Box fields when:
- the client should edit headings, body copy, CTAs, images, or shortcodes in wp-admin
- the page contains repeatable items like cards, FAQs, stats, steps, or pricing tiers
- the content needs structured editing but still belongs to one page only
- you want the design to stay fixed while the content remains editable

Typical page-field sections:
- hero
- intro
- team summary
- service cards
- pricing tiers
- testimonials on one page
- FAQ repeater
- contact details and form shortcode

## When To Split A Section Out

Move a section into its own view only when one of these is true:
- the same section needs to appear on multiple pages
- the section needs placement outside the normal page content flow
- the section should be assigned by Blocksy Content Block conditions
- the page file is becoming too large to scan comfortably

Common split candidates:
- sitewide CTA strip
- reusable testimonial band
- newsletter signup block
- trust/logo wall reused across several pages
- footer-adjacent promo section

When that happens:
- keep the page-level MB View for the unique page body
- move the reusable section to `views/sections/`
- place it with a Blocksy Content Block when placement logic matters
- record both the source file and the live assignment in the placement map

## When A CPT Is The Right Move

Do not use a page field group for content that is actually a content type.

Create a CPT when the content needs:
- many entries
- archive and single templates
- taxonomy filtering
- cross-site reuse in multiple contexts
- separate URLs or long-term editorial management

Examples:
- services become a CPT when each service needs its own page
- testimonials become a CPT when they are reused on many pages
- team members become a CPT when bios need single pages or archives
- case studies become a CPT when they need their own library

## Page-Type Heuristics

### About

Usually best as one page-level MB View.

Typical model:
- static or lightly field-driven hero
- intro copy
- founder story
- values or principles repeater
- optional timeline repeater
- optional CTA band

Promote pieces into reusable sections only if they repeat elsewhere.

### Contact

Usually one page-level MB View.

Typical model:
- static layout shell
- editable contact details fields
- map embed or shortcode field
- form shortcode field
- optional FAQ repeater

This is often a hybrid page: mostly fixed layout, a few structured fields.

### Services

Two common paths:

1. If the page is a marketing overview only:
- one page-level MB View
- repeater or grouped fields for service cards
- static or field-driven detail sections

2. If each service needs its own destination page:
- create a Services CPT
- keep the overview page as a page-level MB View that queries the CPT

### Pricing

Usually start as one page-level MB View with repeaters.

Typical model:
- hero
- pricing tier repeater
- comparison rows repeater
- FAQ repeater
- CTA band

Move to a CPT or options-style model only if pricing data needs to power multiple pages or multiple product families.

## Efficient Build Workflow

Use this order for most standard pages.

1. Define the page goal and section order in `_project-context.md`
2. Decide section by section whether the content is static, field-driven, reusable, or actually CPT-backed
3. Create the WordPress page first if the field group will target a specific page ID
4. Create the `.mbjson` field group only for the sections that need structured editing
5. Build one page-level Twig template with all page-unique sections in order
6. Build CSS using the project token system and the `.mv-page-{slug}` naming pattern
7. Paste the Twig and CSS into the live MB View
8. Assign the page with the appropriate MB View location rule or Content Block placement
9. Record the live object, source file, conditions, and notes in the placement map
10. Refine the live output with Element to LLM and keep the local reference files in sync

## Mockup-To-Meta-Views Workflow

Yes. This is a good fit for the stack.

The efficient handoff looks like this:

1. You provide page mockups or section mockups from an image-generation model
2. I convert the mockups into a section inventory
3. I classify each section as static, field-driven, reusable, or CPT-backed
4. I generate the suggested field model
5. I generate the page Twig and CSS structure
6. I tell you which parts belong in one page-level MB View versus separate reusable sections
7. After the live page exists, you capture the real output with Element to LLM and I refine it against the actual render

The best inputs are:
- full-page mockup
- mobile variant if available
- notes about what the editor should be able to change
- notes about which sections may be reused elsewhere
- notes about whether any cards or lists should later become a CPT

If you provide only a visual mockup with no editorial rules, the first output should usually be a hybrid setup:
- fixed layout and decorative structure in Twig
- fields only for copy, images, CTAs, repeaters, and shortcodes that obviously need editing

## Output Expectations For A New Page Build

For most page requests, the final artifact set should be:
- `_project-context.md` updated with the page goal, view inventory, and placement map entry
- one `.mbjson` file if structured fields are needed
- one local Twig reference file
- one local CSS reference file or paired CSS reference notes
- one live MB View assignment
- optional reusable section files under `views/sections/` when warranted

## Anti-Patterns

Avoid these mistakes:
- creating a CPT for content that only belongs to one page
- creating fields for every paragraph when the page is mostly fixed
- splitting every section into separate MB Views
- keeping the only live template copy inside wp-admin
- mixing page-unique sections and reusable sections without documenting the boundary
- failing to record page ID targeting and live assignment rules in the placement map

## Practical Default

If you are unsure, start here:

- one page
- one field group
- one MB View
- all unique sections in one Twig file
- split only the sections that need reuse
- promote to CPT only when the content wants its own lifecycle

That default is the most efficient Meta Views Stack workflow for normal website pages.
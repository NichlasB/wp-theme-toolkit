# PROJECT CONTEXT

- Project Name: Team Members Demo Site
- Site Type: service business
- Primary Goal: present the team clearly and create trust for prospective clients
- Stack: Blocksy Pro + Blocksy Child + Meta Box AIO + MB Views
- Local Environment: team-members-demo
- Production Host: GridPane
- Date Started: 2026-04-06

## 1. Brand Direction
- Vibe Words:
  - grounded
  - clean
  - confident
- Palette Direction: one accent
- Font Direction: modern editorial headline with a clean sans-serif body
- Visual Notes:
  - light backgrounds with restrained accent usage
  - generous vertical rhythm

## 2. Design Tokens
```css
:root {
  --content-max-width: 72rem;
  --content-narrow-width: 48rem;
  --space-xs: 0.25rem;
  --space-sm: 0.5rem;
  --space-md: 1rem;
  --space-lg: 2rem;
  --space-xl: 4rem;
  --space-2xl: 6rem;
  --text-sm: 0.875rem;
  --text-base: 1rem;
  --text-lg: 1.125rem;
  --text-xl: 1.25rem;
  --text-2xl: 1.5rem;
  --text-3xl: 2rem;
  --text-4xl: clamp(2rem, 5vw, 3.2rem);
}
```
- Palette Mapping:
  - `--theme-palette-color-1` = primary text
  - `--theme-palette-color-2` = accent
  - `--theme-palette-color-3` = subdued text
  - `--theme-palette-color-4` = border
  - `--theme-palette-color-5` = muted background
  - `--theme-palette-color-6` = main surface background

## 3. Naming Conventions
- CPT slugs: kebab-case
- Field IDs: snake_case prefixed by content type keyword
- Field group IDs: snake_case
- MB Views: `view-{subject}-{context}`
- CSS classes: `.mv-{subject}` and `.mv-{subject}--{element}`

## 4. Content Model
### Pages
- home - primary marketing page
- team - team archive landing page
- contact - contact form and office details

### CPTs
- team-member
  - Purpose: store team bios, photos, roles, and contact links
  - Single View: `view-team-single`
  - Archive View: `view-team-archive`

### Taxonomies
- team-department - group team members by department

## 5. Field Schema Inventory
- `team_member_fields.mbjson` - team-member profile fields and repeater links

## 6. View Inventory
- `view-team-single` - Source: `views/single/team-member-single.twig` - Scope: single
- `view-team-archive` - Source: `views/archive/team-member-archive.twig` - Scope: archive
- `home-hero` - Source: `views/sections/home-hero.twig` - Scope: section

## 7. Placement Map
| Artifact | Source File | Live Object | Placement Type | Assigned Location | Conditions | Notes |
|----------|-------------|-------------|----------------|-------------------|------------|-------|
| Team Single | views/single/team-member-single.twig | view-team-single | MB View | Single: team-member | none | primary single template |
| Team Archive | views/archive/team-member-archive.twig | view-team-archive | MB View | Archive: team-member | none | archive cards and intro |
| Home Hero | views/sections/home-hero.twig | Home Hero | Blocksy Content Block | Front page before content | page is home | CTA links to contact page |
| Global Footer | views/sections/site-footer.twig | Global Footer | Blocksy Footer Template | Sitewide footer shell | all front-end pages | Content Block can render `[mbv name="sections/site-footer.twig"]`; add `alignfull` to the root wrapper if the design should break out of the constrained block wrapper |

## 8. Active Layout Patterns
- Section wrapper
- Two-column grid
- Three-column card grid
- Split hero layout

## 9. Open Decisions
- whether the team archive should expose department filters in v1
- whether testimonials should become a second CPT or stay static on the homepage

## 10. Current Build Priorities
1. launch homepage hero and trust sections
2. launch team-member single and archive views
3. launch contact page with embedded form shortcode
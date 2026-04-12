# Twig Patterns Guide

This guide defines the default Twig conventions for MB Views in the Meta Views Stack.

## Core Rule

Keep Twig predictable. Use the current MB Views context object for field output and reserve `mb.*` for helper calls, custom queries, and explicit Meta Box lookups.

## MB Views Context Rule

`mb` is the PHP-function proxy inside MB Views. It is not the default container for normal custom-field output.

Use these rules:
- use `post.field_id` for fields exposed by the current main-query item in a singular or archive view
- use `posts` and `post` inside archive loops
- use `mb.rwmb_meta('field_id', '', post.ID ?: mb.get_queried_object_id())` when you need an explicit page or post lookup, especially in external template files or helper fragments
- never write normal field output as `mb.field_id`

## Field Access

### Text field

```twig
<h2 class="mv-team--name">{{ post.team_name }}</h2>
```

### Rich text field

```twig
<div class="mv-team--bio">{{ post.team_bio }}</div>
```

### URL field

```twig
<a class="mv-team--link" href="{{ post.team_profile_url }}">View profile</a>
```

### Explicit page lookup

```twig
{% set current_page_id = post.ID ?: mb.get_queried_object_id() %}
{% set hero_heading = mb.rwmb_meta('home_hero_title_part_1', '', current_page_id) ?: 'Raw' %}

<h1 class="mv-home--hero-title">{{ hero_heading }}</h1>
```

## Image Pattern

```twig
{% set photo = post.team_photo %}

{% if photo %}
  <img class="mv-team--photo" src="{{ photo.url }}" alt="{{ photo.alt ?: post.team_name }}">
{% endif %}
```

Rules:
- assign the field to a local variable when the value is reused
- always guard image output with a conditional
- provide a sensible fallback alt when the image record does not already contain one

## Conditionals

```twig
{% if post.team_role %}
  <p class="mv-team--role">{{ post.team_role }}</p>
{% endif %}
```

Use conditionals for optional fields, not for every line of output.

## Repeater And Group Loops

```twig
{% if post.team_links %}
  <ul class="mv-team--links">
    {% for item in post.team_links %}
      <li class="mv-team--links-item">
        <a href="{{ item.url }}">{{ item.label }}</a>
      </li>
    {% endfor %}
  </ul>
{% endif %}
```

Rules:
- loop variables should use descriptive names like `item`, `member`, or `card`
- keep list markup semantic when the content is a real list

## Multi-Section Page Views

For pages like home, about, or services, keep one field group and one MB View when the sections belong only to that page.

Use Twig comment dividers to separate each section and keep every section inside the same template as its own `<section>` block.

```twig
{# ── Hero ── #}
<section class="mv-home--hero">
  ...
</section>

{# ── Features ── #}
<section class="mv-home--features">
  ...
</section>
```

Field names should stay section-prefixed so the template remains easy to scan, for example `hero_headline` and `features_heading`.

See `DESIGN_SYSTEM_GUIDE.md` for the full multi-section page pattern, split rules, and CSS organization rule.

## Field Group Page ID Targeting

When a field group should appear on one specific page, use the `include` rule with a placeholder page ID first.

```json
"include": {
  "ID": [0]
}
```

Workflow:
1. Start with `"ID": [0]` as a placeholder in the `.mbjson` file
2. Create the page in WordPress first
3. Note the real page ID from the URL, for example `post=42`
4. Update the `.mbjson` to use the real ID, for example `"ID": [42]`
5. Reload the page editor so the field group appears on that page

If the fields do not appear, check the real page ID first. This is a common two-step setup issue.

## Shortcodes

### Static shortcode

```twig
{{ function('do_shortcode', '[fluentform id="1"]') }}
```

### Shortcode stored in a field

```twig
{{ function('do_shortcode', post.contact_form_shortcode) }}
```

### Shortcode inside archive context

```twig
{{ function('do_shortcode', post.card_shortcode) }}
```

## Archive Context

When rendering the main query, use `post` for the current item and `posts` for archive loops. Use `mb.*` only for helper calls and explicit field lookups.

```twig
{% for post in posts %}
  <article class="mv-team--card">
    <h2 class="mv-team--card-title"><a href="{{ post.url }}">{{ post.title }}</a></h2>
    {% if post.team_role %}
      <p class="mv-team--card-role">{{ post.team_role }}</p>
    {% endif %}
  </article>
{% endfor %}
```

Rules:
- singular main-query fields use `post.*`
- archive loops use `post.*`
- explicit page or post lookups use `mb.rwmb_meta()`
- post links use `post.url`
- post titles use `post.title`

## Fallback Pattern

```twig
{% if post.team_quote %}
  <blockquote class="mv-team--quote">{{ post.team_quote }}</blockquote>
{% else %}
  <p class="mv-team--quote mv-team--quote-is-empty">No quote available.</p>
{% endif %}
```

Use explicit fallbacks for user-visible empty states when silence would look broken.

## Reusable Fragment Rule

MB Views may not support the same file-based include workflow as a local Twig app. Use this rule instead:

- keep reusable fragments in local reference files under `views/`
- copy verified fragments into new MB Views when needed
- do not let near-identical card or section markup drift across views

If your runtime environment supports Twig includes or macros, document that decision in `_project-context.md` before using it.

## Naming Alignment

Match Twig classes to the design-system naming convention:

```twig
<section class="mv-team">
  <div class="mv-team--card">
    <h2 class="mv-team--name">{{ post.team_name }}</h2>
  </div>
</section>
```

## What To Avoid

- deeply nested conditionals when the content model should be simplified instead
- ad hoc class names that do not match the design system
- mixing `mb` and `post` access patterns in the same context without reason
- writing normal field output as `mb.field_id`
- outputting media fields without null checks
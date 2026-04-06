# Twig Patterns Guide

This guide defines the default Twig conventions for MB Views in the Meta Views Stack.

## Core Rule

Keep Twig predictable. Prefer direct field access, explicit conditionals, and small, readable blocks over clever template logic.

## Field Access

### Text field

```twig
<h2 class="mv-team--name">{{ mb.team_name }}</h2>
```

### Rich text field

```twig
<div class="mv-team--bio">{{ mb.team_bio }}</div>
```

### URL field

```twig
<a class="mv-team--link" href="{{ mb.team_profile_url }}">View profile</a>
```

## Image Pattern

```twig
{% set photo = mb.team_photo %}

{% if photo %}
  <img class="mv-team--photo" src="{{ photo.url }}" alt="{{ photo.alt ?: mb.team_name }}">
{% endif %}
```

Rules:
- assign the field to a local variable when the value is reused
- always guard image output with a conditional
- provide a sensible fallback alt when the image record does not already contain one

## Conditionals

```twig
{% if mb.team_role %}
  <p class="mv-team--role">{{ mb.team_role }}</p>
{% endif %}
```

Use conditionals for optional fields, not for every line of output.

## Repeater And Group Loops

```twig
{% if mb.team_links %}
  <ul class="mv-team--links">
    {% for item in mb.team_links %}
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

## Shortcodes

### Static shortcode

```twig
{{ function('do_shortcode', '[fluentform id="1"]') }}
```

### Shortcode stored in a field

```twig
{{ function('do_shortcode', mb.contact_form_shortcode) }}
```

### Shortcode inside archive context

```twig
{{ function('do_shortcode', post.card_shortcode) }}
```

## Archive Context

When rendering archive items, use `posts` and `post`, not `mb`.

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
- single views use `mb.*`
- archive loops use `post.*`
- post links use `post.url`
- post titles use `post.title`

## Fallback Pattern

```twig
{% if mb.team_quote %}
  <blockquote class="mv-team--quote">{{ mb.team_quote }}</blockquote>
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
    <h2 class="mv-team--name">{{ mb.team_name }}</h2>
  </div>
</section>
```

## What To Avoid

- deeply nested conditionals when the content model should be simplified instead
- ad hoc class names that do not match the design system
- mixing `mb` and `post` access patterns in the same context without reason
- outputting media fields without null checks
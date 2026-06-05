# Claude Design Handoff Workflow

This guide defines how Claude Design, screenshots, mockups, HTML exports, or other visual prototypes should feed into the Meta Views Stack.

Claude Design is an upstream design collaborator. It is not the production WordPress builder and it should not become the source of truth for the final site.

## Where Claude Design Fits

Use this sequence when a project benefits from visual exploration:

```text
Project intake
-> Claude Design brief
-> visual prototype or handoff export
-> MVS conversion plan
-> project bootstrap / tokens / page or CPT build
-> live WordPress refinement
```

The production target remains:
- Blocksy Pro for global theme shell
- Blocksy child theme for tokens, utilities, components, and project CSS
- Meta Box AIO for structured content
- MB Views for dynamic templates
- Gutenberg only for intentionally editable areas
- SureForms for forms when the project needs forms

## Good Claude Design Inputs

Before prompting Claude Design, gather:
- business or site type
- audience
- primary goal
- required pages or screens
- priority homepage sections
- brand direction, vibe words, palette, and typography notes
- client editability level: Managed, Guided, Flexible, or Builder
- existing assets, screenshots, documents, or site URLs
- whether desktop, mobile, or both variants are needed

## Claude Design Prompt Shape

Use prompts like this:

```text
Design a website concept for [business/site type].

Audience: [audience].
Primary goal: [goal].
Pages or sections: [page list / section list].
Brand direction: [vibe words, palette, typography].
Implementation target: Meta Views Stack for WordPress, using Blocksy Pro, a Blocksy child theme, Meta Box AIO, and MB Views.
Client editability: [Managed / Guided / Flexible].

Create a clean visual prototype that can be converted into structured WordPress templates. Avoid assumptions that require Elementor, Divi, Webflow, or another page builder.
```

If the project already has a design system, include token names, palette roles, typography scale, component examples, or codebase references.

## Usable Handoff Types

Any of these can be enough for conversion:
- Claude Design page or project URL notes
- screenshots
- desktop and mobile mockups
- standalone HTML export
- handoff folder
- asset folder
- annotated design brief

Best handoff:
- desktop and mobile variants for priority pages
- section-by-section notes
- asset list
- clear editability expectations
- exported HTML or handoff bundle when available

## What The MVS Agent Extracts

From the design handoff, extract:
- page inventory
- section inventory
- reusable section candidates
- token implications
- image and asset needs
- content model candidates
- CPT candidates
- editable, guided, and locked areas
- likely forms and integrations
- QA risks, such as missing mobile states or unclear content hierarchy

## Conversion Rules

- Do not paste exported HTML directly into WordPress as the final implementation.
- Do not convert the design into Elementor widgets unless the project is explicitly classified as `Builder`.
- Treat visual layout as evidence, not as a field model.
- Add fields only where editor control matters.
- Use the smallest workable MVS model: one page, one field group, one MB View by default.
- Split sections only when they need reuse or placement control.
- Promote content to a CPT only when it needs many entries, archives, taxonomies, or separate URLs.

## Next Workflow

After a handoff is available, run:

```text
@DESIGN_HANDOFF_TO_MVS_PROMPT.md run
```

That prompt converts the design source into concrete MVS implementation decisions and routes to the next build prompt.

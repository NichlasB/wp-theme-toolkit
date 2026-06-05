# Example: Start Here Master Workflow

This dry-run shows how `START_HERE_MASTER_WORKFLOW.md` routes a new project without requiring the user to remember the prompt library.

## Scenario

The user wants a website for a local dental practice. They may use Claude Design first. The client wants to edit a bit, but not control the full layout.

## Step 1: Start At The Root

User prompt:

```text
@START_HERE_MASTER_WORKFLOW.md run

New site for a local dental practice. I want to use Claude Design for the first visual direction. The client should be able to edit some copy and images, but I do not want them rebuilding layouts.
```

Expected router output:

```text
Detected mode: A - New Site Intake
Current phase: 0 Intake
Target project: unknown
Status snapshot: missing
Design source: Claude Design planned
Client editability: Guided
Open decisions:
- target LocalWP/project path
- brand direction
- required pages
Recommended next prompt:
`@PROJECT_BOOTSTRAP_PROMPT.md run`
Why this prompt:
- the project needs a target root, project context, and status snapshot before build work begins
```

The agent asks only the minimum missing questions.

## Step 2: Generate Claude Design Prompt

After intake, the master workflow can generate:

```text
Design a website concept for a local dental practice.

Audience: families and adults looking for trustworthy local dental care.
Primary goal: book appointment requests.
Pages or sections: home, about, services, insurance/payment, testimonials, contact.
Brand direction: calm, clean, professional, friendly; light palette with one confident accent.
Implementation target: Meta Views Stack for WordPress, using Blocksy Pro, a Blocksy child theme, Meta Box AIO, and MB Views.
Client editability: Guided. The client can edit approved copy, images, service entries, testimonials, and forms, but layout authority stays with the agency.

Create desktop and mobile concepts that can be converted into structured WordPress templates. Avoid assumptions that require Elementor, Divi, Webflow, or another page builder.
```

## Step 3: Convert The Handoff

After Claude Design returns a prototype or export:

```text
@DESIGN_HANDOFF_TO_MVS_PROMPT.md run
```

Expected conversion summary:

```text
Design source: Claude Design
Handoff quality: usable
Client editability: Guided
Recommended model: home page as one page-level MB View with page fields, services as CPT if each service needs its own URL
Token impact:
- one accent palette
- calm healthcare typography direction
Section decisions:
- hero - page fields
- services overview - CPT-backed if service singles are needed, otherwise page fields
- testimonials - CPT-backed if reused across pages
- insurance CTA - reusable section
- contact band - page fields plus SureForms shortcode
CPT candidates:
- services
- testimonials
Editable surface map:
- homepage layout - locked
- hero copy/image - fields
- services - fields or CPT entries
- testimonials - fields or CPT entries
- contact form - SureForms
Next workflow:
`@PAGE_SCOPING_CHECKLIST_PROMPT.md run`
```

## Step 4: Continue Existing Toolkit Flow

From this point the existing workflow takes over:

```text
@PROJECT_BOOTSTRAP_PROMPT.md run
@DESIGN_TOKENS_PROMPT.md run
@PAGE_SCOPING_CHECKLIST_PROMPT.md run
@NEW_PAGE_PROMPT.md run
@NEW_CPT_PROMPT.md run
```

The master workflow remains the recovery point if the user returns after a long break.

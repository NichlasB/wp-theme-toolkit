<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Design Tokens Prompt

Use this prompt to generate or update the project's color mapping, typography direction, and token block from a brand brief.

---

## Purpose

Run this when:
- the project is new and needs a token baseline
- the brand direction changed
- the existing token system is incomplete or inconsistent

Do not use this prompt as a substitute for page or CPT generation. It should update the shared token system and project context, not generate full view markup.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `d1-setup/PROJECT_CONTEXT_TEMPLATE.md`
- `d3-guides/DESIGN_SYSTEM_GUIDE.md`
- `_project-context.md` in the target project

---

## Required Inputs

- current `_project-context.md`
- brand brief or vibe words
- palette direction: monochrome, one accent, or full palette
- any existing Blocksy palette decisions

If inputs are missing, ask for only the minimum needed to choose a palette direction and token mapping.

---

## Required Outputs

Update:
- the token block in `style.css` when needed
- the design-token and palette mapping section in `_project-context.md`

If the user asks for font recommendations, document them in `_project-context.md` rather than hardcoding font-family rules into individual views.

Do not touch individual MB View CSS in this workflow unless the user explicitly asked for token replacement or the token structure is currently broken.

---

## Workflow

### 1. Audit the current token state
- check whether the canonical token block already exists
- check whether `_project-context.md` documents palette roles clearly
- check whether the project is currently monochrome, accent-led, or full-palette

### 2. Choose the palette strategy
- map the requested brand direction to the Blocksy six-slot palette system
- duplicate values across slots when the project intentionally uses a minimal palette
- keep palette-role descriptions explicit in `_project-context.md`

### 3. Normalize the token block
- ensure spacing and typography values match the documented scale
- add missing canonical tokens
- avoid one-off tokens unless the user explicitly wants a custom extension documented in `_project-context.md`

### 4. Update project context
- document the chosen palette direction
- document the role of each Blocksy palette slot
- document any font recommendations as project guidance rather than per-view CSS

### 5. Flag downstream review needs
- if the token changes will affect existing views, recommend the appropriate review prompt

---

## Rules

- keep spacing and type sizes on the documented scale
- map colors to Blocksy palette slots instead of introducing raw values
- do not solve brand direction by adding more breakpoints or more utility classes
- do not create view-level color systems that bypass Blocksy
- do not invent extra spacing tiers without documenting them in the project context

---

## Output Format

```text
Files reviewed: [count]
Files updated: [count]
Palette direction: [monochrome / one accent / full palette]
Token changes:
- [change]
- [change]
Project-context updates:
- [change]
Follow-up review needed: [yes/no]
```

If follow-up review is needed, name the most relevant next prompt.

Proceed with the design-token update now.
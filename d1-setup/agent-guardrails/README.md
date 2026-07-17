# Agent Guardrails — Local Adapter

The canonical guardrail templates and profiles live at:

```text
wp-workflow-toolkit/d1-setup/agent-guardrails/
```

The shared bundle supports:

- WordPress plugins;
- conventional WordPress themes and child themes; and
- Meta Views Stack site projects.

Use this toolkit's local entry point:

```text
@INSTALL_AGENT_GUARDRAILS_PROMPT.md run
```

The installer detects the target from source evidence. For a Meta Views Stack project it adds rules for source-controlled MB Views references, database-resident active views, placement maps, Meta Box JSON, Blocksy assignments, editability, and separate code/database deployment channels.

Do not copy this adapter directory into a project. The installer composes the shared common templates with exactly one selected profile.

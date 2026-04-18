<!-- Task Type: Single-Phase | See _TASK_RUNNER.md for execution instructions -->

# Session Handoff & Context Transfer

Use this prompt near the end of a working chat when you want to continue the same Meta Views Stack site project in a fresh chat or with a different AI assistant or model.

Its job is to capture the current session as both:
- a local handoff artifact in the target project root
- a paste-ready Context Transfer Prompt that can be dropped into the next chat

This workflow complements `SESSION_BOOTSTRAP_PROMPT.md` and `RESTORE_POINT_PROMPT.md`.

- `SESSION_BOOTSTRAP_PROMPT.md` maps the project at the start of a chat.
- `RESTORE_POINT_PROMPT.md` protects or compares filesystem state.
- this workflow transfers conversation context plus verified current state to the next chat.

---

## Purpose

Run this workflow when:
- work will continue in a new chat
- you want to switch models or assistants without losing project context
- you want a written close-out before pausing
- you want the next chat to inherit the current plan, decisions, risks, and likely next step

This is a handoff workflow, not an implementation workflow.

Use conversation history as the primary narrative source, but verify current state from the filesystem and git before presenting it as fact.

If the likely next step in the next chat will modify files and no fresh restore point exists for the session, recommend `RESTORE_POINT_PROMPT.md` in the handoff.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `d3-guides/WORKFLOW_QUICK_REFERENCE.md`
- `d1-setup/STACK_REFERENCE.md`
- `d4-prompts/ds1-setup/SESSION_BOOTSTRAP_PROMPT.md`
- `d4-prompts/ds1-setup/RESTORE_POINT_PROMPT.md`

Use those files to understand:
- normal target-selection rules
- how this toolkit distinguishes orientation vs implementation workflows
- which next prompts are most likely to matter in the next chat
- where runtime or database-backed site state may not be verifiable from files alone

---

## Required Output File

Create a temporary Markdown file in the target project root using this filename:

```text
session-handoff.tmp.md
```

If a file with that name already exists, overwrite it.

Do not create this file inside the toolkit itself unless the user explicitly asks you to run the workflow on the toolkit or another atypical folder.

Treat this file as temporary local workflow context. It should not be committed.

---

## Atypical Target Fallback

Most uses of this prompt should target a site project or Blocksy child theme, but occasionally the user may explicitly point it at an atypical folder.

If that happens:
- honor the explicit target choice
- infer the best available identity from `style.css`, `_project-context.md`, `README.md`, or folder naming
- mark inferred values clearly in the output
- prioritize operational files and project context over forcing a normal child-theme handoff
- keep the handoff useful for the next chat even if the target is documentation-first rather than a normal site project

---

## What To Review

Review the current conversation and the current project state with a bias toward continuity, not exhaustiveness.

### 1. Conversation coverage
- determine whether the current chat appears fully available, partially available, or unavailable beyond the recent turns
- if the full conversation is not available, say so clearly and do not invent missing history

### 2. Verified current state
- target project identity and root path
- whether `session-context.tmp.md` exists and whether it appears current enough to use as helper context
- key files or artifacts touched this session when they can be verified on disk
- current git branch and clean vs dirty worktree state when applicable
- latest restore point context when it is directly available from the project or current session context
- current workflow stage such as bootstrap, active build, review-ready, pre-launch, or deployment prep

### 3. Work completed in this chat
- work that was actually completed in the current session
- files created, updated, or reviewed
- outcomes that were verified vs only discussed

### 4. Key decisions and reasoning
- important design, data-model, content-model, or implementation decisions made in the chat
- why each decision was made
- trade-offs discussed
- whether each decision is verified in files, inferred from chat, or still pending implementation

### 5. Standing instructions and preferences
- recurring preferences or instructions given in this conversation
- formatting, pacing, or workflow requests that should carry forward
- if none were given beyond normal toolkit behavior, say so explicitly

### 6. Open threads and next steps
- unfinished work
- unresolved questions
- dependencies, blockers, or follow-up checks
- the most relevant next toolkit prompt for the next chat

### 7. Risks and unknowns
- database-only or runtime-only state that cannot be verified from files alone
- MB Views or Blocksy Content Block assignments that may exist only in the database
- CPT visibility, permalink flush, or other wp-admin confirmations still needed
- any chat-only claims that could not be verified directly

---

## Output File Format

Write the file in this structure:

```text
# SESSION HANDOFF & CONTEXT TRANSFER

- Project: [name]
- Date: [YYYY-MM-DD]
- Conversation coverage: [full history / partial history / unavailable]
- Assessed from: [path]
- Child theme root: [path]
- session-context.tmp.md: [present / missing]
- Restore point context: [summary]
- Git state: [branch + clean/dirty/not a repo]

## 1. Verified Current State
- Workflow stage: [bootstrap / active build / review-ready / pre-launch / deployment prep / unclear]
- Filesystem summary: [short summary]
- Key changed files: [short summary]
- Validation summary: [what was actually verified]

## 2. Work Completed In This Chat
- [completed item]
- [completed item]

## 3. Key Decisions & Reasoning
- Decision: [decision] | Why: [reason] | Status: [verified in files / inferred from conversation / pending verification]
- Decision: [decision] | Why: [reason] | Status: [verified in files / inferred from conversation / pending verification]

## 4. Standing Instructions & Preferences
- [instruction or preference]
- [instruction or preference]

## 5. Open Threads / Next Steps
- [unfinished item]
- [unfinished item]

## 6. Risks / Unknowns
- [risk or unknown]
- [risk or unknown]

## 7. Suggested Fresh-Chat Start
- Review: [files or artifacts to read first]
- First toolkit prompt: [prompt name or "none yet"]
- Restore-point recommendation: [yes / no / already covered]

## 8. Paste-Ready Context Transfer Prompt
[plain-text prompt written in second person]
```

Keep the file concise and scannable.
Aim for continuity and accuracy, not a full audit.

When something is based only on conversation memory, label it clearly.
When something depends on runtime or database state, label it as unverified unless directly confirmed.

---

## Context Transfer Prompt Requirements

After writing `session-handoff.tmp.md`, generate a paste-ready Context Transfer Prompt for a new chat.

That prompt must:
- be written in second person
- be self-contained
- tell the next assistant what project is active and what role to adopt immediately
- separate verified current state from inferred or unverified items
- capture key decisions, reasoning, standing instructions, open threads, and immediate next steps
- tell the next assistant to read `session-handoff.tmp.md` and `session-context.tmp.md` if they exist
- tell the next assistant not to treat database-only Blocksy or MB Views state as verified unless confirmed
- recommend `RESTORE_POINT_PROMPT.md` before edit-heavy work if no fresh restore point is already in place
- avoid inventing missing conversation history when full chat coverage is unavailable

Wrap the generated Context Transfer Prompt in a plain-text fenced code block for clean copy-paste.

---

## Output Format

After writing the file, summarize the result in chat using this structure:

```text
Target project: [name]
Handoff file created: [path]
Conversation coverage: [full / partial / unavailable]
Git state: [summary]
Restore point context: [summary]
Recommended first prompt: [prompt name or none]
```

Then list:
- the top verified current-state points
- the top decisions carried forward
- the top open threads

After that summary, print the paste-ready Context Transfer Prompt in a fenced code block.

---

## Constraints

- Do not modify project implementation files.
- Do not create a permanent checked-in documentation file unless explicitly asked.
- Do not claim runtime or database-only state as verified unless directly confirmed.
- Do not auto-commit, auto-stash, or auto-push anything.
- If saved-file status or git status cannot be confirmed, say so clearly.

---

Proceed now:

1. Identify the target project using `_TASK_RUNNER.md`.
2. Review the available conversation history.
3. Verify the current filesystem and git state where possible.
4. Create `session-handoff.tmp.md` in the target project root.
5. Summarize the handoff in chat.
6. Output the paste-ready Context Transfer Prompt in a plain-text code block.

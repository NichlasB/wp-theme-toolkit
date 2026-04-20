<!-- Task Type: Two-Phase | See _TASK_RUNNER.md for execution instructions -->

# Toolkit Lessons Audit & Retrospective

---

Use this prompt at the end of a working chat when the conversation produced lessons, mistakes, rework, or clarifications that the toolkit itself should learn from, so future site-building sessions do not repeat the same gaps.

This workflow targets the toolkit, not a child-theme or site project. That is the deliberate exception to the usual toolkit-target rule in `_TASK_RUNNER.md`.

This is a retrospective workflow, not an implementation workflow for site code. Phase 1 proposes changes to toolkit files. Phase 2 applies only the changes you explicitly approve.

This workflow complements:
- `SESSION_HANDOFF_PROMPT.md` which captures conversation state for the next chat
- `d3-guides/WORKFLOW_QUICK_REFERENCE.md` which documents the operating sequence
- the review and pre-launch prompt families that reveal recurring toolkit gaps during real site work

Those workflows protect continuity and execution quality. This workflow protects the toolkit's ability to improve over time based on real usage.

Do not use this workflow for one-off project bugs, normal build or review work that went as expected, or preferences that only apply to the current site. If the issue is project-specific, fix it in the project and leave the toolkit unchanged.

---

## Purpose

Run this workflow when:
- a chat produced an avoidable issue that a better toolkit rule or prompt could have prevented
- you clarified something during the chat that other site projects using this toolkit would also benefit from
- the agent repeated the same class of mistake that existing toolkit guidance did not catch
- a build, review, or pre-launch session needed post-hoc fixes that reveal a gap in setup, design-system, Twig, Blocksy, deployment, or review guidance
- a design, performance, accessibility, UX, or workflow pattern emerged that deserves to become a default toolkit rule

Do not run this workflow for:
- one-off project-specific issues with no general pattern
- preference changes that only apply to the current site
- routine work that went as expected with no lessons to extract

Use conversation history as the primary source for candidate lessons, but verify against current toolkit files before proposing edits. Do not invent lessons from gaps when conversation coverage is partial.

---

## Primary References

Before starting, read:
- `_TASK_RUNNER.md`
- `README.md`
- `d3-guides/WORKFLOW_QUICK_REFERENCE.md`
- `TOOLKIT_QA_REFERENCE.md`
- `PROJECT_CONTEXT_REFERENCE.txt`

Use those files to understand:
- which toolkit files exist and where each type of guidance belongs
- which files are safe to edit automatically and which require manual follow-up
- how existing prompts are structured so proposed additions match the house style
- what has already been documented so you do not propose duplicates

---

## Target & Output File

**Target:** the `wp-theme-toolkit` repository root. Not a site project.

Create a temporary Markdown file in the toolkit root using this filename:

```text
toolkit-lessons.tmp.md
```

If a file with that name already exists, overwrite it.

Treat this file as temporary local workflow context. It should not be committed, and `.gitignore` should ignore the exact filename `toolkit-lessons.tmp.md`.

If the workspace contains both a site project and the toolkit as separate folders, source candidate lessons from the project chat but write the proposal file and any approved edits against the toolkit root.

---

## Atypical Target Note

This prompt is the deliberate exception to the toolkit-target rule from `_TASK_RUNNER.md`.

Confirm you are operating against the toolkit root before writing the proposal file. If you cannot confidently identify the toolkit root, stop and ask the user to confirm the target path.

---

## Files In Scope For Proposed Edits

Edits may be proposed against:
- prompt files under `d4-prompts/`
- guides under `d3-guides/`
- `TOOLKIT_QA_REFERENCE.md` for Q&A-style lessons that are not yet prescriptive enough for a prompt edit
- `README.md` or `readme.txt` only when workflow order or structure has actually changed
- `_TASK_RUNNER.md` only when target-selection, task-type, or execution wording truly needs tightening
- `CHANGELOG.md` only with a concise `Unreleased` entry for notable rule changes

Edits should not be proposed against:
- helper scripts under `d2-scripts/` - script changes are flagged but must be implemented and tested manually
- `PROJECT_CONTEXT_REFERENCE.txt` unless structural facts have actually changed
- `PRE_LAUNCH_CHECKLIST.md` or `DEPLOYMENT_CHECKLIST.md` content rows - this workflow targets the toolkit and does not update project tracking
- `d5-examples/` content - examples reflect historical site work, not toolkit rules
- entirely new prompt files - flag these as manual follow-up rather than an auto-apply diff

If a lesson implies a helper-script change or a brand-new prompt file, surface it as a flagged note for manual follow-up, not as an auto-apply proposal.

---

## What To Review

### 1. Conversation coverage

Determine whether the chat appears fully available, partially available, or unavailable beyond recent turns. If coverage is partial or unavailable, say so clearly and limit scope to what is directly visible. Do not invent missing lessons.

### 2. Candidate lessons from the chat

Look for:
- mistakes the agent made that existing toolkit guidance could have prevented
- mistakes the user had to catch and correct that existing toolkit guidance did not warn about
- rework cycles where the same class of problem appeared more than once
- decisions or clarifications that would be useful as defaults for future Meta Views Stack site projects
- post-build or post-review fixes that reveal a gap in setup, design-system, Twig, Blocksy, deployment, or review prompts
- performance, accessibility, UX, or operational issues not caught by existing reviews
- user preferences stated in the chat that would reasonably apply across most site projects using this toolkit

### 3. Classification of each candidate

For each candidate, assign exactly one category:
- **Missing guidance** - no existing toolkit rule or prompt covers this; toolkit edit warranted
- **Existing guidance ignored** - guidance exists but was not emphatic, positioned, or testable enough; tighten wording or move it higher in priority
- **Novel issue** - genuinely new situation the toolkit could not reasonably have predicted; log in `TOOLKIT_QA_REFERENCE.md` for now
- **Project-specific** - would not generalize to most projects using this toolkit; skip

Only the first three are toolkit-worthy. The fourth is intentionally out of scope.

### 4. Generality check

For each toolkit-worthy candidate, confirm it would apply to most site projects built with this toolkit, not just the one worked on in this chat. If it only applies to a narrow project type, mark generality as partial and note the condition so the proposed guidance can be scoped correctly.

### 5. Existing coverage check

For each candidate, scan the proposed target file and adjacent files for existing coverage. If the point is already covered, either skip the lesson or propose a tightening edit rather than a new addition. Duplicates weaken the toolkit over time.

### 6. Proposed change

For each approved candidate, define:
- which file to edit
- the change type (`new section`, `tightened wording`, `new checklist item`, or `no change`)
- the exact proposed diff with enough surrounding context that Phase 2 can apply it unambiguously

Prefer minimal, surgical edits over large rewrites.

---

## Output File Format

Write `toolkit-lessons.tmp.md` using this structure:

```text
# TOOLKIT LESSONS AUDIT PROPOSAL

- Source chat topic: [site/project name or short description]
- Date: [YYYY-MM-DD]
- Conversation coverage: [full / partial / unavailable]
- Toolkit root: [path]
- Candidate lessons considered: [N]
- Toolkit-worthy lessons proposed: [N]
- Skipped as project-specific or already covered: [N]
- Apply status: [pending approval]

## 1. Session Summary
- What was worked on: [short]
- What went well: [short]
- What went wrong or was suboptimal: [short]

## 2. Proposed Lessons

### Lesson 1: [short title]
- Category: [missing guidance / existing guidance ignored / novel issue]
- What happened: [brief, factual, from chat]
- Root cause: [brief]
- Generality: [applies to most projects / applies to project type X / narrow]
- Proposed target file: [path]
- Existing coverage check: [none / partial at <section> - tightening / already covered - skip]
- Change type: [new section / tightened wording / new checklist item / no change]
- Proposed diff:
  ~~~diff
  [minimal context lines]
  + [added line]
  + [added line]
  ~~~
- Rationale: [one or two sentences tying the diff back to the chat evidence]
- User decision: [pending / approve / reject / defer]

## 3. Flagged For Manual Follow-Up
- [item] - [why it cannot be auto-applied; typically script, structural, or new-file changes]

## 4. Skipped / Out Of Scope
- [item] - [reason: project-specific / already covered / insufficient evidence]

## 5. Phase 2 Instructions
- Mark each lesson's `User decision` as `approve`, `reject`, or `defer`
- Re-run this prompt with: `@TOOLKIT_LESSONS_AUDIT_PROMPT.md run phase 2`
- Only approved lessons will be applied; rejected and deferred lessons will be left untouched
```

Keep the file concise. Aim for durable, high-signal proposals, not exhaustive capture.

When a lesson is based only on conversation memory with no filesystem verification, label it clearly.

Zero toolkit-worthy lessons is a valid outcome. Do not pad the proposal to reach a quota.

<!-- PHASE 1 END -->

---

## Phase 2: Apply Approved Lessons

Phase 2 runs only when the user explicitly triggers it after reviewing `toolkit-lessons.tmp.md`.

When triggered:

1. Read `toolkit-lessons.tmp.md` from the toolkit root.
2. Only process lessons marked `User decision: approve`.
3. For each approved lesson:
   - re-verify the existing coverage check against the current file contents
   - apply the proposed diff as written unless the target file has changed materially since Phase 1, in which case mark the lesson `needs revision` and move on
   - do not reformat or rewrite surrounding content; keep edits surgical
4. After applying:
   - update `toolkit-lessons.tmp.md` by changing each applied lesson's `User decision` to `applied` with a short confirmation note
   - append a short `Unreleased` entry in `CHANGELOG.md` only if the rule change is notable
5. Do not commit, stage, or push anything. Leave git state as-is for the user to review.

If any approved lesson cannot be applied cleanly, mark it `User decision: needs revision` with a reason and continue with the remaining lessons. Do not force partial applies on a single lesson.

This workflow does not update `PRE_LAUNCH_CHECKLIST.md` or `DEPLOYMENT_CHECKLIST.md` because it targets the toolkit itself, not a site project.

---

## Output Format

After writing `toolkit-lessons.tmp.md` in Phase 1, summarize in chat using this structure:

```text
Target: toolkit repository
Proposal file: [path]
Conversation coverage: [full / partial / unavailable]
Candidate lessons considered: [N]
Toolkit-worthy lessons proposed: [N]
Skipped as project-specific or already covered: [N]
Flagged for manual follow-up: [N]
```

Then list:
- the top proposed lessons with their target file and change type
- any flagged manual follow-ups
- a clear instruction to review `toolkit-lessons.tmp.md`, mark decisions, then run Phase 2 when ready

For Phase 2, summarize which lessons were applied, which were skipped as `needs revision`, and any remaining manual follow-ups.

---

## Constraints

- Do not modify toolkit files during Phase 1. Phase 1 is proposal only.
- Do not apply any lesson the user has not explicitly marked `approve`.
- Do not propose auto-applied diffs against helper scripts in `d2-scripts/`.
- Do not claim a lesson is new without running the existing-coverage check first.
- Do not invent lessons to fill space. Zero toolkit-worthy lessons is a valid outcome.
- Do not auto-commit, auto-stash, or auto-push anything in either phase.
- When conversation coverage is partial or unavailable, keep scope to what is directly visible and say so.
- Do not treat user preferences expressed in the chat as toolkit rules unless they would clearly apply across most projects using this toolkit.

---

Proceed with Phase 1 now.
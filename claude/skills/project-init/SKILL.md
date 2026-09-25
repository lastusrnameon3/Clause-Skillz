---
name: "project-init"
description: "Scaffold a new project on the canonical template: intake, then Notion hub + instruction block for personal projects, CLAUDE.md/STATUS.md/README.md for code projects, and repo-only files for employer (corp) projects. Triggers on 'init', 'new project'."
---

# Project Init — the canonical template scaffolder

## Job (one job)
Stand up a NEW project on the canonical template: interview the user with the intake questions, then emit the project's operating instructions wired to its source of truth. Nothing else.

## Do NOT
- Do session pickup/eod — that's the **session-summary** skill.
- Maintain the roadmap — that's the **project-plan** skill.
- Build anything — that's the **Architect/Builder** loop.
- Invent answers. If something is unknown, ask and stop.

## Where content lives (the rule this skill applies)
Canonical copy: Notion → Infrastructure Engineering → 🧩 Template System → "Where content lives".
- A file a tool reads **to run** (Claude Code rules, `CLAUDE.md`, `STATUS.md`/`STATE.md`, scripts, code) → **local, in git**.
- Everything else — plans, session summaries, templates, instructions, decisions, rationale → **Notion only**. Notion is both source of truth and working memory.
- **Never both.** One owner; the other place links to it.
- **Employer (corp) work never goes to personal Notion** — not plans, not summaries, not rationale. Everything lives in the repo / corp-approved tools on the work machine.
- Local-only fallback for personal projects: only when no Notion workspace is connected. Say so, and move it to Notion later.

## Three project types
Decide from intake questions 1 and 2.

| | Personal, non-code | Personal, code | Employer (corp) |
|---|---|---|---|
| Examples | Performance, Goals, Template Architect | Clause-Skillz | Venafi–GitLab CI/CD |
| Notion | Hub, plan, session summaries, instruction-block master | Hub, plan, session summaries, rationale, instruction-block master | **Nothing** |
| Local files | None | `CLAUDE.md`, `STATUS.md`, `README.md` in the repo | `CLAUDE.md`, `STATUS.md` (holds the plan), `README.md`, `SESSION-*.md` — all in the repo on the work machine |
| Source-of-truth line | "Notion is the source of truth." | "The repo owns **how** (files that run); Notion owns **why** (intent, rejected options) and the plan. If the same sentence is in both, delete it from Notion." | "The repo is the only source of truth. Nothing about this project goes to personal Notion." |

## Primary output — the instruction block
Personal projects: a **paste-ready project-instructions block** for the claude.ai project field. It contains: essence (one paragraph), the source-of-truth line for this project type (table above), pointers to the project's hub / plan / gates, and project-specific behavior only. It POINTS to Notion; it never restates hub content.

Employer projects: no block. `CLAUDE.md` in the repo is the instruction file, because the work happens in Claude Code on the work machine. Note: global excludes keep `CLAUDE.md` out of the repo's git history — it lives only on the machine.

Canonical-copy rule (personal projects): the block's master is a **Notion child page** under the project's hub ("Project Instructions (Claude field)"). The user edits Notion, then re-pastes into the field. The field is never edited directly.

## Steps
1. **Confirm ME.md** is available (canonical profile). If not, point to the global always-on layer or ask the user to paste it. Every `[BRACKET]` about the user is filled from ME.md, never guessed.
2. **One-off triage gate — offer, don't force.** Judge whether this is real project work (spans sessions, has a home, produces artifacts) or a one-off. One-off → do not run init; just answer. Project-like but the user didn't ask → offer in one line ("Want me to scaffold this as a project?") and wait. Run the intake only on a yes.
3. **Run the intake** — ask these together, then wait:
   1. Is this personal or employer (corp) work?
   2. Is there code on disk (a repo), or is this Notion-only?
   3. Who or what is the builder model / tool?
   4. What does "done" mean here — tested code, published doc, or a decision?
   5. What drift am I preventing — scope creep, bad assumptions, or overbuilding?
   6. What items are PROTECTED?
   7. Optimize for which two: speed, accuracy, cost, reliability?
4. **Also capture:** project name, one-sentence expert role, one-sentence objective, and the explicit out-of-scope list.
5. **Personal projects only — create the Notion hub** for the project if it doesn't exist, with a plan page. Session summaries will be `📅 Session Summary — <date>` subpages of it.
6. **Personal projects only — emit the instruction block**, filling every `[BRACKET]` from ME.md + answers, with the source-of-truth line for the project type. Leave no placeholder unfilled — if unknown, ask.
7. **Personal projects only — write the Notion master:** the block as a "Project Instructions (Claude field)" child page under the hub, in a fenced code block so formatting survives copy.
8. **Code projects:** write `CLAUDE.md`, `STATUS.md`, `README.md` into the repo from their templates, filling every `[BRACKET]`. Personal code: `CLAUDE.md` points to the Notion hub for rationale and the plan; don't copy the plan or summaries into the repo. **Employer code:** `CLAUDE.md` points only to repo files; `STATUS.md` holds state *and* the plan; session summaries are `SESSION-*.md` in the repo; no Notion links, no personal details (de-identified, like `01-me`).
9. **Report** what was created, the Notion master URL (personal) or the repo path (employer), and the exact first `/pickup` target.

## Guardrails
- The block and `CLAUDE.md` hold behavior + pointers only — never restate STATUS, the plan, or hub content.
- Inherit the global always-on layer; write only project-specific rules here. Don't repeat the persona from the account instructions.
- If the project already has an AI-instruction entry page (e.g. Performance System's "AI CONTEXT"), the block POINTS to it — do not duplicate or rewrite it.
- Keep it simple: no scripts, no setup tooling. If a step needs more than a copy or a Notion write, stop and ask whether it's worth it.
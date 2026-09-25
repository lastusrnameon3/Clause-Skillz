---
name: "session-summary"
description: "Generate an end-of-day session summary (/eod) to a Notion Session Summary subpage of the project's hub, or resume from one (/pickup). Employer (corp) work never goes to Notion — it stays in a local SESSION-*.md in the repo; local also when no Notion is connected."
---

# Session Summary

This skill has two directions: **`/eod`** writes a summary at the end of a session, and **`/pickup`** reads one back to resume work the next time. They're two ends of the same handoff — the value of `/eod` is entirely in how well it sets up `/pickup` to work without the user having to re-explain anything.

The core idea: a session contains far more context than what ends up in code or tickets — dead ends tried, why one approach was chosen over another, things that are almost-but-not-quite done. That context evaporates the moment the conversation ends unless something captures it deliberately. This skill is that capture mechanism.

## When this triggers

- **`/eod`** — explicit end-of-day trigger, but also fires for "let's wrap up", "summarize what we did today", "I need to step away, can you write up where we are"
- **`/pickup`** — explicit resume trigger, but also fires for "where did we leave off", "what was I working on", "catch me up", "let's continue from yesterday"

If it's ambiguous which direction the user wants (e.g., they just say "summary"), ask — generating a new summary and resuming from an old one are different operations and shouldn't be guessed at.

## Generating a summary (`/eod`)

### Step 0: Work out where this project keeps its memory

**First: is this employer (corp) work?** If the project belongs to the user's employer — work repos, work systems, anything under corporate data rules — the summary **never goes to Notion**, connected or not. Personal Notion is not an approved store for employer data. Write `SESSION-<YYYY-MM-DD>.md` in the project's repo on the work machine (whether it's committed follows that repo's rules — global excludes cover `.claude/` and `CLAUDE.md`, not `SESSION-*.md`) and stop Step 0 there. If it's unclear whether a project is employer work, ask once.

**Otherwise, default: Notion is the working memory.** Summaries go to Notion whenever a Notion workspace is connected — never to a local file, and never to both. One copy, readable from any surface (including the phone), costs one write per `/eod`; two copies cost two writes and start drifting on day one. Check, in order:

1. Has this project already established a Notion location earlier in this conversation, or is one obvious from context (e.g., the project's plan page or prior `📅 Session Summary` pages)?
2. Search the connected Notion workspace for the project's hub / Operating System / plan page. Summaries go as subpages of it. If the hub exists but has no summaries yet, start them there — do not fall back to a local file just because none exist.
3. **Only if no Notion workspace is connected** in this session (e.g., a corporate machine without the Notion connector), write a local file: `SESSION-<YYYY-MM-DD>.md` in the project workspace. Say so in the confirmation, so the user knows this one is not in Notion.

Personal code repositories are not an exception: a repo may keep its own state file that the coding tool reads (e.g. `STATE.md`), but the session summary still goes to Notion. If you find an old local `SESSION-*.md` for a project that has a Notion hub, mention it once so it can be moved — don't keep writing beside it. If it's genuinely unclear which hub a project belongs to, ask the user once rather than guessing.

### Step 1: Reconstruct the session, don't just skim the tail

Read back through the actual conversation — not just the last few messages. Decisions made early in a session are exactly the kind of thing that gets forgotten by the time someone picks the work back up, and they're often more valuable to capture than whatever happened most recently. If a summary already exists for today (found via Step 0), treat this as an update to it rather than starting fresh — merge in what's new rather than creating a duplicate.

### Step 2: Write the summary using this exact structure

Use this template precisely — the section names and order matter, because `/pickup` (and the user's own memory of this format) depend on the structure being consistent every time.

```markdown
# Session Summary — <YYYY-MM-DD>

## Worked On
One line per item. What it was, not what was done to it.

## Completed
Specific completed items only. Not "made progress" — what it does now.

## Decisions Made
| Decision | Alternative | Why This One |
|----------|-------------|---------------|
| ... | ... | ... |

## Still Open
Each item needs: what it is, what specifically remains, file and line if applicable.

## Items for Later
Things raised mid-session that aren't already tracked in the project's overall
plan — one line each. Only goes here if it's genuinely new; check the existing
plan first so this doesn't duplicate something already on the roadmap.

## Blockers
What stopped progress or needs someone else. Ticket reference if it exists.
If none: state "None."

## Context That Would Be Lost
Reasoning, dead ends, discoveries not captured in code or tickets.
This section is not optional — it is the highest-value part of the summary.
Keep each item to one or two sentences — quick and concrete, not a retelling.

## Tomorrow — First Action
One sentence. The exact next step. Not a goal. Not a list.

## Files Touched
| File | Current State |
|------|----------------|
| ... | ... |
```

A few notes on filling this in well:

**Worked On vs. Completed are different sections on purpose.** "Worked On" is the topic list — what areas got attention, regardless of whether they finished. "Completed" is strictly things that are actually done and working. Don't let "made progress on X" sneak into Completed; it belongs in Still Open instead, described honestly.

**Decisions Made is for anything where a real alternative existed.** If there was only one reasonable way to do something, it doesn't need a row here. This table is for the cases where the user (or a future Claude) might otherwise wonder "wait, why didn't we just do it the obvious other way" — write down the alternative and the actual reason it was rejected, not a vague justification.

**Still Open needs to be actionable, not just a list of topics.** "Fix the import bug" is not enough — what specifically is broken, where (file/line if you have it), and what's already been ruled out. The test for whether an item is well-written: could someone with zero memory of this session pick it up and know where to start?

**Items for Later is for loose threads, not roadmap work.** During a session, things come up that aren't the task at hand — "we should probably revisit X eventually," a tangent that got noted and dropped. If the project has a standing plan (see the `project-plan` skill), check it before adding anything here — if it's already a phase or a tracked future item, it doesn't need to be duplicated in this session summary too. This section is only for things that would otherwise be lost entirely, not a second copy of the existing roadmap.

**Context That Would Be Lost is the section people skip and shouldn't — but keep it tight.** This is explicitly not optional. Think about what's in your head right now that isn't in any file: why an approach was abandoned, a constraint that only became clear partway through, something that looked like a bug but turned out to be expected behavior, a hunch about what's causing something that hasn't been confirmed yet. If this section is empty, that's a signal to look harder, not a sign there was nothing worth capturing. At the same time, each item should be one or two sentences — a quick, concrete flag, not a retelling of how it was discovered. The goal is that someone scanning this section in twenty seconds catches everything important; a wall of paragraphs defeats that.

**Tomorrow — First Action must be a single concrete sentence, not a list.** "Continue working on the import pipeline" is a goal. "Run the new TSV parser against the FantasyShark export and confirm column alignment holds" is a first action. If there are several candidate next steps, pick the most logical one rather than listing options — the next session should be able to start moving immediately without having to make a planning decision first.

**Do not fill gaps with assumptions.** If something about the session is genuinely unclear — an open question never resolved, a decision discussed but not confirmed — say so explicitly rather than guessing at what probably happened. A flagged unknown is far more useful than a confidently wrong summary.

### Step 3: Save it where Step 0 determined it belongs

If the project's memory lives in Notion: create or update a page titled `📅 Session Summary — <YYYY-MM-DD>` as a subpage of the project's Operating System / plan page, using the exact section structure above as the page content. If a page for today already exists, update it rather than creating a second one for the same date.

For employer work, or when no Notion workspace is connected (Step 0, case 3): save as `SESSION-<YYYY-MM-DD>.md` in the project workspace. If a file for today's date already exists, update it rather than creating a duplicate.

Either way, use the actual current date — check it rather than assuming.

### Step 4: Confirm briefly

After saving, give the user a short confirmation — not a restatement of the whole summary, since they just watched you write it. Something like: "Saved to the Session Summary page for today. Tomorrow's first action: [the one sentence]." (or "Saved to SESSION-2026-06-15.md — employer work, kept local" / "— no Notion connected here" if local) This makes it obvious the handoff worked and gives them the single most useful piece of information without re-reading the whole thing.

### Step 5: Ask about updating the plan

If this project has a standing plan (a `PLAN.md` file, or a "Project Plan" page in Notion — whichever Step 0 identified, or the user has otherwise indicated this project tracks a roadmap), ask — don't assume — "Want me to update the plan too?" This is a separate operation (handled by the `project-plan` skill) and shouldn't run automatically; some sessions are minor enough that there's nothing roadmap-worthy to reconcile, and the user should get to make that call each time rather than have it happen by default.

If they say yes, hand off to the `project-plan` skill using this session's "Decisions Made," "Completed," "Still Open," and "Items for Later" sections as the input — that skill knows how to reconcile session content into the standing plan without duplicating what's already tracked there.

## Resuming a session (`/pickup`)

### Step 1: Find the right summary

Same discovery as Step 0 above, in reverse: work out where this project's memory lives. If it's Notion, search the workspace for the project's Operating System / plan page and look for the most recent `📅 Session Summary — <date>` subpage beneath it. If it's local files, look for the most recent `SESSION-*.md` in the project workspace. If there are several candidates and it's not obvious which is most recent or relevant, ask rather than guessing — resuming from the wrong day's summary is worse than asking a clarifying question.

### Step 2: Read it fully, then brief the user

Don't just dump the raw file back at the user — they wrote it (or had it written) to skip re-reading everything themselves. Synthesize a short briefing covering: what was completed last time, what's still open, any blockers, and the first action. Surface anything from "Context That Would Be Lost" that's directly relevant to getting started again — that section exists precisely so it doesn't get re-lost on pickup.

### Step 3: Pick up the first action

Unless the user redirects, treat the "Tomorrow — First Action" line as the actual next thing to do, and either do it or confirm before doing it depending on how significant it is. The whole point of writing a crisp first action during `/eod` is that `/pickup` shouldn't require a planning conversation — it should be able to just go.

## A note on scope

This skill is intentionally general — it's not tied to any one project, language, or codebase. The structure works for a software project, a research task, a writing project, or anything else with enough complexity that picking it back up cold would otherwise cost real time. Apply the same nine-section structure regardless of domain; only the content changes.
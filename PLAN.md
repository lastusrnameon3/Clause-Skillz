# Clause-Skillz — Project Plan

*Last updated: 2026-09-24*

The standing roadmap. `STATE.md` is the slice-by-slice commit log; session summaries (what happened
on a given day) live in Notion under the ⚙️ Clause-Skillz hub. This is where the whole thing is headed.

## Current Phase

Phase C. The migration off Continue is done and installed on the Mac. Audit A1 (2026-09-23/24)
trimmed the system: 1 hook left (`credential-guard`), no install scripts. The corporate Windows machine
has not been set up, and **`credential-guard` has not been exercised live through the client**.

## Phases

| Phase | Status | What It Covers |
|---|---|---|
| A — Migrate off Continue | **Done** | Continue EOL at 2.0.0. 13 rules converted `globs:` → `paths:`, 26 prompts → 6 skills, 4 hooks built, repo renamed to `Clause-Skillz`, subtree distribution retired. Slices 9–11. |
| B — Mac install | **Done, partially verified** | Global excludes set, tree copied to `~/.claude/`. `/context` lists the 5 universal rules; `/skills` lists the 6. **Re-copy needed after Slice 12** so `~/.claude/` drops the 3 removed hooks. `credential-guard` unverified live. |
| C — Corporate Windows machine | **Not started** | Clone, run the 2 README git-config lines in Git Bash, copy rules + skills to `%USERPROFILE%\.claude\`. Hooks won't run there: managed settings block user-level hooks, so `credential-guard` is advisory only at work. Decided 2026-09-24: no workaround. |
| D — Notion why-only restructure | **Not started** | Domain pages still restate rule bodies. They should carry *why this exists* and *what was rejected*, then link to the file. §2 of the reconciliation doc. The largest remaining piece of work. |

## Decided, Not Yet Built

- **Live-fire `credential-guard` on the Mac.** Never run through the client; its tests were static stdin. Ask Claude Code to write a file containing a fake key and confirm the deny.
- **Fix `CHEATSHEET.md`'s account-skill section.** It lists `terse-mode`, `session-summary`, `ste` and others as available everywhere. They are account skills: present in the desktop app, absent in Claude Code. The file needs a surface-split table.

## Items for Later

- Move `.continue/` to `archive/continue-v2.0.0/` so the repo root is unambiguous. Cosmetic.
- Split `03-writing`: roughly half is the session-summary format, which only matters at `/eod`. Moving that half into the session-summary skill trims always-on context with no behavior loss. (Audit A1 finding M2 — compare against the skill's format first.)
- Test `paths: ["**/README.md"]` for the README standard in `03-writing` (Audit A1 M3). Risk: path rules fire on read, so a brand-new README may not trigger it.
- Quarterly audit of this repo against current Anthropic docs — next due ~2026-12.
- Publish more of the six skills to the account if desktop-app use grows. Three are published (`challenge`, `review-lens`, `jira`); `security-review`, `userdocs` and `plainify` were held back as repo-and-terminal work.
- Delete the 4 `[DELETE]` duplicate Notion pages — pending manual action since 2026-07-10; the API cannot trash them.

## Explicitly Out of Scope

- **Team distribution.** Personal scope means non-scripting teammates get nothing. A deliberate tradeoff against the stated goal that they run this work — taken because whether `.claude/` is permitted in corporate repos is unanswered, and undisclosed tooling found in an MR is a worse conversation than not shipping one. Revisit only if tool approval is obtained.
- **Rebuilding Continue.** `.continue/` stays archived and unmaintained. It is the only record of the prior design; it is not a fallback.
- **Porting the 7 account skills into the repo.** `terse-mode`, `context-compress`, `usage-stats`, `quick-reference`, `commit-message`, `code-review`, `session-summary` already exist account-side. Duplicating them creates two copies to maintain. Revisit only if terminal use becomes primary.

## Open Decisions

- **Is `.claude/` permitted in corporate repos?** Unanswered. Everything in "Out of Scope — team distribution" hangs on it. The honest read: personal scope buys time to prove value before asking, but in a regulated shop the asking should eventually happen.
- **Does a custom `code-review` beat the bundled one?** Claude Code ships `/code-review`. The Continue version had a severity-prefix grammar (`bug:`/`risk:`/`nit:`/`q:`) and audit/operational auto-expansion that a generic reviewer will not have. Try the bundled one on real work first; port over the same name only if it falls short — personal skills override bundled by name.

## Done

- **Audit A1 + Slice 12** (2026-09-24). Hooks 4 → 1, install scripts removed (2 README lines), `01-me`/`02-thinking` contradiction fixed, `00-project-context` template trimmed, dead files removed, session summary moved to Notion, project instructions block rewritten, repo git state repaired. Findings: Notion → Template System → Audit A1.
- **Migration off Continue complete** (2026-09-17). 13 rules, 6 skills, 4 hooks, repo renamed, pushed.
- **`17-documentation-ste.md` written and committed** (2026-09-10). Notion had described it as deployed since 2026-08-10; it had never existed.
- **Notion reconciled** (2026-09-10). 14 pages: hub restructured into a Current / Reference / Archived index, supersession banners applied, Personas carries the full command rename table.
- **Repo renamed** `continue-rules` → `Clause-Skillz` (2026-09-11).
- **Mac installed** (2026-09-17). Rules and skills confirmed loading via `/context` and `/skills`.
- **3 skills published to the account** (2026-09-17): `challenge`, `review-lens`, `jira`.
- **`review-gate` defect found and fixed** (2026-09-17). Found by dogfooding the system on itself — `/security-review` on this repo's own hooks.
- **`17` corp-machine question closed uninvestigated** (2026-09-11), Frank's call, rejection recorded.

## Standing Lesson

Two defects reached `main` because verification only exercised the happy path: the subtree prefix,
broken for months and never noticed because nobody ran the quickstart; and `review-gate`, recorded in
`STATE.md` as verified by a test that could not fail for the reason that mattered.

**A test that cannot fail for the reason you care about is not a test.** Applies to every acceptance
gate in this plan — which is why Phase B is marked *partially* verified rather than done.

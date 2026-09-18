# Clause-Skillz — Project Plan

*Last updated: 2026-09-18*

The standing roadmap. `STATE.md` is the slice-by-slice commit log; `SESSION-*.md` is what happened
on a given day. This is where the whole thing is headed.

## Current Phase

Phase C. The migration off Continue is done and installed on the Mac; the corporate Windows machine
has not been set up, and **no hook has been exercised live through the client**. Everything built so
far is verified by static test, not by use.

## Phases

| Phase | Status | What It Covers |
|---|---|---|
| A — Migrate off Continue | **Done** | Continue EOL at 2.0.0. 13 rules converted `globs:` → `paths:`, 26 prompts → 6 skills, 4 hooks built, repo renamed to `Clause-Skillz`, subtree distribution retired. Slices 9–11. |
| B — Mac install | **Done, partially verified** | `Setup-Machine.sh` run, tree copied to `~/.claude/`, `settings.json` merged preserving `theme`. `/context` lists the 5 universal rules; `/skills` lists the 6. **Hooks unverified live** — `review-gate` was the exception and it had a defect. |
| C — Corporate Windows machine | **Not started** | Clone, `Setup-Machine.ps1`, copy to `%USERPROFILE%\.claude\`. Two known risks: hooks need bash + `jq` via Git Bash, and `~` in `settings.json` hook paths may not expand on Windows. |
| D — Notion why-only restructure | **Not started** | Domain pages still restate rule bodies. They should carry *why this exists* and *what was rejected*, then link to the file. §2 of the reconciliation doc. The largest remaining piece of work. |

## Decided, Not Yet Built

- **Live-fire every hook.** `credential-guard`, `session-start` and `eod-reminder` have never run through the client. Their tests were static stdin. The `review-gate` defect — a hook that denied the first Bash command of any kind — was invisible to exactly that kind of test.
- **Fix `CHEATSHEET.md`'s account-skill section.** It lists `terse-mode`, `session-summary`, `ste` and others as available everywhere. They are account skills: present in the desktop app, absent in Claude Code. The file needs a surface-split table.
- **Update the Claude project instructions block.** Still says "Notion is canonical." Under the current split Notion is canonical for *intent*; the repo is canonical for *behavior*. §4 of the reconciliation doc.
- **Clean up `POWERSHELL-COMMUNITY-REVIEWER.md`.** Still references "your Frank personas" and a v1 `config.json` block — the one file that survived the Slice 4 de-identification pass.

## Items for Later

- Move `.continue/` to `archive/continue-v2.0.0/` so the repo root is unambiguous. Cosmetic.
- Split `03-writing`: roughly half is the session-summary format, which only matters at `/eod`. Moving that half into the session-summary skill trims always-on context with no behavior loss.
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

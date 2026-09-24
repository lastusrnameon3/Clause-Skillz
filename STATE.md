# STATE — Clause-Skillz

---

## 2026-07-10 — v2 Migration Initiated

### Built
- GitHub repo `lastusrnameon3/Clause-Skillz` — 15 files, 15 commits
- Rules 01–11 in `.continue/rules/` (v1 format — JSON-era, Frank-specific)
- Notion doc tree under Infrastructure Engineering → Clause-Skillz
- 18 slash commands defined in JSON `slashCommands` array (Notion only, never in repo)
- 4 files created never pushed: `.vscode/settings.json`, `.vscode/powershell.code-snippets`, `scripts/new-project-setup.ps1`, `scripts/new-project-setup.sh`
- 7 adapted skills (from caveman/cavecrew) — source of truth: `adapted-skills.zip`

### Decisions + Reason
- Full migration to current Continue format (YAML + prompt files) — JSON config deprecated per Continue docs
- Layered rules model (universal / domain / project) — enables non-work use (hobby, fantasy football, random projects)
- Skill mapping: tool-delegation → rule; other 6 → prompts; code-review replaces /gitready; quick-reference replaces planned 98-cheatsheet
- STATE.md loop: /state reads at session start, /eod writes at session end
- config template stays out of repo (contains endpoint/key refs) — Notion only
- Session summaries stay human-readable; /jira separate from /eod
- GitHub username canonical: `lastusrnameon3`
- Continue is EOL (final 2.0.0 release) — format is stable, no future changes expected

### Unresolved
- Private endpoint model string — not yet supplied by user
- 4 `[DELETE]` duplicate pages in Notion — API cannot trash, manual action pending

### Constraints
- Continue is EOL (final 2.0.0) — no future format changes, build against current spec
- No agents at work — all summaries and state files are human-readable, not agent logs
- config.yaml stays in Notion only — contains endpoint/key references, never enters repo

### Next Slice Queued
- Slice 7: config.yaml template in Notion (blocked on model string)
- Slice 8: docs, URL audit, release

---

## 2026-07-10 — Slices 1–6 Executed

### Built
- Repo restructured: `.continue/rules/`, `.continue/prompts/`, `.continue/session/`, `scripts/`, `.vscode/`, `STATE.md`
- Universal rules layer: 00-project-context, 01-me, 02-thinking, 03-writing, 04-tool-delegation (5 rules, alwaysApply: true)
- Domain rules layer: 10-code, 11-security, 12-git-workflow, 13–16 deployment family (7 rules, glob/regex-scoped)
- v1 rules 01–11 deleted
- 18 prompts migrated from JSON slashCommands to `.continue/prompts/*.md` files
- 7 adapted skills integrated: tool-delegation (rule), terse/normal/commit/compress/usage/help/review (prompts)
- review.md merges code-review terse format with security/audit auto-clarity override from old 05-diff-review
- help.md lists all 25 prompts + 12 rules
- STATE.md loop: /state reads state, /eod writes state + session summary, /pickup reads STATE.md directly (no paste)

### Decisions + Reason
- frank-* prompts renamed to role-based (infra-review, teamlead-review, etc.) — generalizes away from one person's name
- /gitready removed — superseded by /review with integrated security/audit override
- 05-diff-review not migrated — content folded into review.md auto-clarity section
- 06-readme and 07-session merged into 03-writing.md — avoids duplication between universal and domain layers
- Tool-delegation is a rule (always-on), not a prompt — it's a background decision framework
- help.md replaces planned 98-cheatsheet — same purpose, already written as adapted skill
- /pickup no longer requires manual paste — reads STATE.md at repo root directly

### Unresolved
- Private endpoint model string — still pending from user
- 4 `[DELETE]` duplicate pages in Notion — still pending manual deletion
- Notion pages not yet updated to reflect v2 structure

### Constraints
- Same as above — no changes

### Next Slice Queued
- Slice 7: config.yaml template in Notion (parallel, blocked on model string — can complete with placeholder)
- Slice 8: docs, URL audit, merge v2-migration to main, tag v2.0.0

---

## 2026-07-10 — v2 Migration Complete (Slice 8)

### Built
- URL audit: all misspelled GitHub username instances fixed to canonical `lastusrnameon3` in repo and Notion
- Quickstart scripts updated: create `.continue/prompts/` and `STATE.md` stub on project init
- README expanded: layered rules model, full 26-prompt list, config note
- Notion hub page: v2 structure summary added, old URLs fixed
- config.yaml page created in Notion (14 models, `MODEL_STRING_TBD` placeholder)
- config.json page retitled "(deprecated)"
- v2-migration merged to main, tagged v2.0.0

### Decisions + Reason
- config.yaml stays in Notion only — contains endpoint/key references
- Old Notion pages (v1 structure, adversarial frameworks, daily workflow, VS Code settings) left in place as reference — not deleted
- 4 `[DELETE]` duplicate pages still pending manual deletion by user

### Unresolved
- Private endpoint model string — still TBD, find-and-replace `MODEL_STRING_TBD` in Notion when ready
- 4 `[DELETE]` duplicate pages in Notion — manual action

### Constraints
- Continue is EOL (final 2.0.0) — format is stable
- No agents at work — all summaries human-readable

### Next Slice Queued
- None — v2 migration complete. Next work is project-specific usage.

---

## 2026-09-10 — Slice 9: STE rule pushed, Notion/repo roles split

### Built
- `.continue/rules/17-documentation-ste.md` created — the file Notion has documented as deployed since 2026-08-10 but which was never committed. Domain layer, `globs: "**/DEPLOYMENT-*.md"`, `name: ste` so it is also invokable as `@ste`.
- `help.md` cheat sheet updated — domain rules table now lists 17. Counts are now 26 prompts + 13 rules.
- `README.md` — 17 added to the layered-rules list; new "Where Things Live — Notion vs This Repo" section.

### Decisions + Reason
- **17 ported dense, not verbatim.** Notion page 17 is ~8KB (36-row substitution table, worked examples, procedural rewrite walkthrough). Rule files are token-conscious and load into every matching context. Kept: scope, compliance note, sentence/verb/word/punctuation limits, warnings taxonomy, 9-point self-check, the 19 highest-frequency substitutions. Dropped to Notion: full table, worked examples. File states where the full set lives.
- **Compliance note carried verbatim.** ASD-STE100 spec and dictionary are ASD copyright; this encodes paraphrased rules and a public word list. "Never claim certified compliance" is the line most likely to be lost in a port — it is now in the rule file, not only in Notion.
- **De-identified on the way in**, matching the Slice 4 pass. No employer names, no vault product names, no internal endpoints.
- **README seam preserved** — 17 deliberately does not glob `README.md`; `03-writing` owns that reader. Stated in the rule file so it does not get "fixed" later.
- **Notion = what/why, repo = how.** Notion owns intent, rationale, rejected options, and the `config.yaml` template. The repo owns the working artifacts. Behavior questions resolve against `.continue/`; rationale questions resolve against Notion. Replaces the prior "Notion is canonical for everything" framing, which could not survive the repo being the only place the rules actually run.

### Unresolved
- **How `17` came to be documented as deployed without ever being committed.** Either it was authored on the corporate copy and never pushed — which would mean GitLab→GitHub ran backwards, against the stated hard guard — or it was designed in Notion and the page was written in the wrong tense. Not yet answered. Worth answering: one is a break in repo discipline, the other is a doc bug.
- Notion pages still describe v1 (see the Slice 8 "left in place as reference" decision) with no marker on the pages saying so. Recommendations drafted, not executed.
- Personas page still names `/gitready` and the `/frank-*` commands, all renamed or removed in Slice 4.
- Skills Master Reference says 13 rules — correct as of this commit, coincidentally; it was wrong before.
- `POWERSHELL-COMMUNITY-REVIEWER.md` at repo root still references "your Frank personas" and a v1 `config.json` block. Survived the Slice 4 de-identification pass.
- Private endpoint model string — still `MODEL_STRING_TBD` in Notion.

### Constraints
- Continue is EOL (final 2.0.0) — format stable, no future changes.
- No agents at work — summaries and state files stay human-readable.
- `config.yaml` stays in Notion only.
- `git subtree` prefix stays pinned at `.continue/rules` — nothing else in the repo ships to corporate projects.

### Next Slice Queued
- Slice 10: Notion reconciliation — execute the recommendations (stamp v1 pages, fix Personas command names, retense page 17).

---

## 2026-09-10 — Slice 10: migrate off Continue, rename to Clause-Skillz

### Built
- `claude/` — the Claude Code tree: 13 rules, 6 skills, 4 hooks, `settings.json`. Installs to `~/.claude/`.
- `scripts/Setup-Machine.ps1` / `.sh` — one-time, idempotent machine bootstrap. Sets `core.excludesfile` and appends `.claude/`, `CLAUDE.md`, `CLAUDE.local.md`.
- Repo renamed `continue-rules` → **`Clause-Skillz`** (spelling deliberate). README rewritten around Claude Code.
- Notion reconciled: hub is now an index with Current / Reference / Archived tables; supersession banners on 10 pages; Personas carries the full command rename table.

### Decisions + Reason
- **Personal scope, not repo scope.** Claude config installs to `~/.claude/` and never enters a work repo. Whether `.claude/` is permitted in corporate repos is unanswered, and an undisclosed tool discovered in an MR is a worse conversation than not shipping one.
- **Global git excludes, not per-repo `.gitignore`.** A `.gitignore` entry naming `.claude/` is itself a commit that discloses the tool. `core.excludesfile` discloses nothing.
- **Machine bootstrap, not project init.** The excludes are machine setup; putting them in `init` re-runs them per project and, worse, may never run before the first repo — which is the leak.
- **26 prompts → 6 skills.** Seven were already installed Claude skills (ported *into* Continue in Slice 5); porting back makes a second copy. Three belong to session-summary. Eleven review/decision prompts collapsed into `/review-lens` and `/challenge` — eleven near-identical descriptions compete and mis-trigger.
- **Only `security-review` is model-invocable.** It should fire unprompted on credential-shaped work. Everything else is deliberate.
- **Things you would forget became hooks, not skills.** Skills are what you reach for; hooks run regardless. A checklist has the same failure mode as remembering.
- **`credential-guard` matches value-shaped secrets only** — keyword + assignment + 16-char value, or a PEM block. Keyword-only matching blocked four of six benign test cases, including `Get-Credential` and `$env:VAULT_TOKEN`.
- **`.continue/` archived, not deleted.** It is a working v2.0.0 artifact and the only record of the prior design.
- **Subtree distribution retired, not fixed.** Personal scope removes the need entirely.

### Verified
- 13/13 rules converted by script (`globs:` → `paths:`, `alwaysApply:` dropped, `regex:` moved to hook).
- All 6 SKILL.md frontmatters parse; names match directories; no undeclared `$placeholders`.
- `credential-guard` smoke-tested on 6 payloads: literal API key **blocked**, PEM key **blocked**, prose mentioning "password" **passed**, `Get-Credential` **passed**, `$env:VAULT_TOKEN` **passed**, empty payload **passed**. All rc=0, no stderr.
- Test caught a real defect: the PEM pattern began with `-`, so grep parsed it as options and private-key detection never fired. Fixed and retested.
- `review-gate` verified: denies first commit of a session, passes the second. **This test was inadequate — see Slice 11.** It could not distinguish a working `if:` filter from an ignored one.
- 15 Claude Code API claims verified against current docs before building. `if:` is tool-events-only, so `eod-reminder` filters in-script.

### Unresolved
- ~~GitHub rename not executed~~ — **done.** Repo is `Clause-Skillz` on GitHub.
- ~~Slice 9 and this commit are unpushed.~~ — **done, pushed.**
- ~~`17-documentation-ste.md` on the corporate machine~~ — **CLOSED 2026-09-11, not investigated.** Frank's call: the repo version is authoritative, use it. Whether a pre-2026-08-10 copy existed corp-side is now moot — anything there gets overwritten by the repo copy. Rejected the investigation because the only thing it could have produced was a process finding about a system being retired this week; the cost of knowing exceeded the value.
- Notion domain pages still restate rule bodies; they should carry *why* and *what was rejected*, then link to the file.
- `POWERSHELL-COMMUNITY-REVIEWER.md` still references "your Frank personas" and a v1 `config.json` block — survived the Slice 4 de-identification pass.
- 4 `[DELETE]` duplicate Notion pages — API cannot trash them.

### Constraints
- Personal scope means **non-scripting teammates get nothing**. Deliberate tradeoff, not an oversight — revisit if tool approval is ever obtained.
- Hooks require `jq` and bash; Git Bash covers Windows.
- `config.yaml` stays in Notion only.

### Next Slice Queued
- Push. Then restructure the Notion domain pages to why-only.

---

## 2026-09-17 — Slice 11: review-gate false-positive fix

Found by dogfooding — `/security-review` on this repo's own hooks. The first Bash
command of the session was a `cat`; `review-gate` denied it with the commit message.

### Built
- `claude/hooks/review-gate.sh` rewritten: detection moved out of `settings.json` and into the script. Tokenized in awk.

### Decisions + Reason
- **The hook is now self-contained.** The old version did zero command inspection — it read only `session_id` and denied once. Correctness depended entirely on `if: "Bash(git commit *)"` in settings. When that filter is not honored, the hook denies the **first Bash command of any kind**. `if:` is kept as belt-and-braces; it is no longer load-bearing.
- **Tokenized, not regex.** Three cases a naive pattern gets wrong: `git -C /repo commit` (flag with a value between `git` and the subcommand), `git log --grep=commit` (word present, not the subcommand), `echo git commit` (`git` present, not the command). Requires `git` to be the first token of a segment.
- **awk, not `while read`.** The bash version silently dropped its only line: `printf '%s'` emits no trailing newline, so `read` returned non-zero and the loop body never ran. Every input passed.

### Verified
12 payloads, all correct. PASS: `cat`, `git status`, `git log --grep=commit`, `echo git commit`, `git commit-tree`, `grep -r "git commit" .`, empty. DENY: `git commit -m`, `git -C /repo commit`, `git -c user.email=… commit`, `git add -A && git commit`, `cd /r ; git commit`. Once-per-session still holds.

### Lesson — the verification, not the bug
The Slice 10 entry claimed `review-gate` was verified. That test ran the commit as the
first Bash call of the session, so a working `if:` and an ignored `if:` produced identical
output. The recorded verification proved nothing. **A test that cannot fail for the reason
you care about is not a test.** Corrected in place above.

Two defects in this hook reached `main` because the verification only exercised the happy
path — the same class of gap as the subtree prefix bug, which also went unexercised for months.

### Unresolved
- Whether `if:` is honored at all by the installed client — untested, and now moot for this hook.
- `credential-guard` has not been exercised live. Its 6-payload test was static stdin, not a real Edit/Write.
- ~~`session-start` and `eod-reminder` unexercised.~~ — **moot.** Both removed 2026-09-24; see Slice 12.

### Next Slice Queued
- Live-fire `credential-guard`: ask Claude Code to write a file containing a fake key; confirm the deny.

---

## 2026-09-24 — Slice 12: audit pass, hook cut, script cut

### Built
- Removed 3 superseded planning docs from the Claude.ai project (Notion audit H4).
- Deleted `claude-home` staging copy — was byte-identical to this repo plus 9 stale patch/plan files; git subtree/patch handoffs through it had left this repo with stale lock files and an unfinished `git am` session, now cleared.
- Removed hooks `session-start`, `review-gate`, `eod-reminder` (Boris's rule: delete, use without them, re-add only on repeat failure — kept `credential-guard`, the only one that blocks anything).
- Removed `scripts/Setup-Machine.sh`/`.ps1`, `scripts/new-project-setup.sh`/`.ps1`, `POWERSHELL-COMMUNITY-REVIEWER.md` — install is now 2 commands in README, no script needed.
- Trimmed `01-me.md` (removed line contradicting `02-thinking`'s ambiguity rule) and `00-project-context.md` (removed unfilled template section, duplicated in Notion's CLAUDE.md template).

### Decisions + Reason
- **Simplicity over scaffolding.** Frank's standing instruction: audit should find the easiest path, not just remove tokens. A setup script that runs two `git config` lines is more moving parts than the two lines themselves.
- **Hooks are enforcement, not reminders.** Only a hook that blocks something earns the complexity. The other three duplicated things already covered by an always-loaded rule or a standing habit.

### Verified
- Not yet — `/context` and `/hooks` recheck pending next Claude Code session on the Mac.

### Unresolved
- Corp machine (Phase C, PLAN.md) still not started; `credential-guard` still never live-fired.
- Whether corp GitLab already runs secret-detection/push-protection — check before building any hook workaround there.

### Next Slice Queued
- Live-fire `credential-guard` on the Mac; confirm `/hooks` shows only the one hook.

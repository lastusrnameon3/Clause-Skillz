# Clause-Skillz — cheat sheet

Claude Code, VS Code or terminal. Personal scope: everything lives in `~/.claude/`, nothing in a repo.

---

## Three mechanisms — know which you are looking at

| | Fires | You type | Guarantee |
|---|---|---|---|
| **Rules** | Automatically | nothing | Deterministic — glob match or always-on |
| **Hooks** | Automatically | nothing | Enforced by the client, not by the model |
| **Skills** | On invocation | `/name` | You chose it |

Rules and hooks need no action. **Only skills are typed.**

---

## Rules — 13, automatic

**Universal — every session, every project.** No `paths:` field.

| File | Does |
|---|---|
| `00-project-context` | Reads `STATE.md` before responding |
| `01-me` | Audit before proposing · simpler option first · direct feedback, no praise-padding |
| `02-thinking` | Challenge before building · no ties · record what was rejected |
| `03-writing` | README standard + session summary format |
| `04-tool-delegation` | Summarize tool output; keep exact line numbers and error text verbatim |

**Domain — only when a matching file is in context.**

| File | `paths:` |
|---|---|
| `10-code` | `**/*.{ps1,py,sh,js,ts}` |
| `11-security` | `**/*.{ps1,py,sh,yaml,yml,json,env,cfg,conf,ini,toml}` |
| `12-git-workflow` | `.gitlab-ci.yml`, `.github/workflows/*.yml`, `**/*.md`, `CHANGELOG*` |
| `13-deployment-checklist` | `**/DEPLOYMENT-checklist.md` |
| `14-deployment-windows` | `**/DEPLOYMENT-windows.md` |
| `15-deployment-linux` | `**/DEPLOYMENT-linux.md` |
| `16-deployment-python` | `**/DEPLOYMENT-python.md` |
| `17-documentation-ste` | `**/DEPLOYMENT-*.md` |

Open a `.ps1` → `10-code` and `11-security` attach. Open `README.md` → `12-git-workflow` attaches,
`17` does not. STE governs deployment docs only; README stays plain English by design.

---

## Skills — 13, typed

```
/review-lens <lens>     infra · teamlead · architect · blindspot · sidebiz · community
/challenge <mode>       challenge · premortem · steelman · tradeoff · breakit
/security-review        also self-invokes on credential-shaped work
/code-review            one line per finding, severity prefixes — replaces the bundled /code-review
/commit-message         Conventional Commits from the diff — writes only, never commits
/userdocs               README from the 03-writing standard
/jira                   card blocks from session work
/plainify <mode>        names · comments · both
/session-summary        /eod writes today's summary, /pickup resumes — employer work stays local
/project-init           scaffold a project: personal, code, or employer
/architect-builder <j|u|d|g|e|quick>   slice spec → build → fresh-context judge → you decide
/terse-mode             compressed replies; "normal mode" turns it off
/quick-reference        this list, in-session
```

No argument on `review-lens` or `challenge` → it lists the lenses and stops.

**These 13 live in this repo — it's their one source.** Account skills (claude.ai) reach Claude Code
only when you sign in with a claude.ai account; they land in `~/.claude/skills/synced/` and run as
`/anthropic-skills:<name>` when a local skill has the same name. API-key, `apiKeyHelper`, and
Bedrock sessions — typical at work — get none, which is why these are here.

---

## Hook — 1, automatic (Mac only)

| Hook | Event | Behavior |
|---|---|---|
| `credential-guard` | PreToolUse `Edit\|Write` | **Denies** a write containing a literal secret or PEM private key |

At work, managed settings block user-level hooks — `credential-guard` does not run there.
`session-start`, `review-gate`, `eod-reminder` were retired 2026-09-24 (duplicated a rule or a habit).

`credential-guard` matches **value-shaped** secrets — keyword + assignment + 16-char value, or a PEM
block. Not bare keywords: `# never log the password`, `Get-Credential`, and `$env:VAULT_TOKEN` all
pass. Bare-keyword context is what `11-security` is for.

---

## Continue → Claude Code

| Was | Now |
|---|---|
| `.continue/rules/` `globs:` | `~/.claude/rules/` `paths:` |
| `alwaysApply: true` | omit `paths:` |
| `11-security` `regex:` on content | `credential-guard` hook — blocks instead of advising |
| `.continue/prompts/*.md` | `~/.claude/skills/<name>/SKILL.md` |
| `/gitready` | `/code-review` |
| `/frank-infra` … `/frank-sidebiz` | `/review-lens <lens>` |
| `/challenge` `/premortem` `/steelman` `/tradeoff` `/breakit` | `/challenge <mode>` |
| `/simplify` `/comment` | `/plainify <mode>` |
| `/eod` `/pickup` `/state` | `/session-summary` (`00-project-context` reads `STATE.md`) |
| `/help` | `/skills` (built in) |
| `config.yaml` personas | `/review-lens`, `/challenge` |
| `git subtree` distribution | none — copy to `~/.claude/` per machine |

---

## Diagnostics

| Command | Answers |
|---|---|
| `/context` | Which rules actually loaded. **The check that matters.** |
| `/skills` | Which skills are visible |
| `/memory` | Memory file locations; opens them |
| `/doctor` | Config problems |

Smoke test after install, in any repo:

1. `/context` → 5 universal rules under **Memory files**
2. Open a `.ps1` → `/context` again → `10-code` now listed
3. `/skills` → all 13 present

If a rule is missing from `/context`, it did not load. Check the frontmatter parses and the file is
in `~/.claude/rules/`.

---

## Install / update

See README → *Install*. Mac: rules + skills + hook, merging only the `hooks` block into
`settings.json`. Work (Windows): rules + skills only. Both set `core.excludesfile` so `.claude/`,
`CLAUDE.md`, and `CLAUDE.local.md` never enter a repo.

---

## Per-project overrides

Project-specific context goes in `CLAUDE.local.md` at the repo root — globally excluded, never
committed. A committed `CLAUDE.md` would be visible in your MRs.

`STATE.md` **is** committed. It carries no tool branding and reads as an ordinary project state file.

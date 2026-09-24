# Clause-Skillz

Rules, skills, hooks, and workflow standards for AI-assisted infrastructure engineering.

> **Status.** This repo began as `continue-rules`, targeting the Continue extension for VS Code.
> Continue reached end of life at 2.0.0. The system is migrating to **Claude Code, personal scope**:
> everything installs to `~/.claude/` and nothing is committed into work repos.
> `.continue/` is kept as the archived v2.0.0 artifact — it is not maintained.

## Structure

```
Clause-Skillz/
  claude/
    rules/          ← 13 rules: universal (00-04) + path-scoped domain (10-17)
    skills/         ← 6 invokable skills
    hooks/          ← 4 enforced lifecycle hooks
    settings.json
    CHEATSHEET.md   ← invocation reference: what fires automatically vs what you type
  .continue/        ← ARCHIVED. Continue v2.0.0. Not maintained.
  .vscode/          ← Shared editor settings and snippets
  STATE.md          ← Project state file (session continuity)
  BOUNDARY-DEFINITION.md
```

## Install — personal scope

Once per machine — keeps `.claude/`, `CLAUDE.md`, `CLAUDE.local.md` out of every repo without a
committed `.gitignore` entry (which would itself disclose the tooling):

```bash
git config --global core.excludesfile ~/.gitignore_global
printf '.claude/\nCLAUDE.md\nCLAUDE.local.md\n' >> ~/.gitignore_global
```

Then, on every update, copy the tree in:

```bash
cp -r claude/rules claude/skills claude/hooks claude/settings.json ~/.claude/
```

Git Bash covers both lines on Windows.

Verify: `/context` in any repo lists the five universal rules under **Memory files**. Open a `.ps1`
and `10-code` appears; open a `.md` and it does not.

Requires `jq` and bash. Git Bash satisfies both on Windows.

## Rules — layered model

Rules load from frontmatter. No manual invocation.

**Universal — every session** (no `paths:` field):

- `00-project-context` — reads STATE.md, project template stub
- `01-me` — behavioral defaults (audit first, simpler option, direct feedback)
- `02-thinking` — adversarial defaults (challenge before building)
- `03-writing` — README standard + session summary format
- `04-tool-delegation` — context-efficient tool output handling

**Domain — only when a matching file is in context** (`paths:` glob):

- `10-code` — code standards (`.ps1`, `.py`, `.sh`, `.js`, `.ts`)
- `11-security` — credential, certificate, and secret handling
- `12-git-workflow` — commit format, MR/PR standards
- `13`–`16` — deployment checklists (shared, Windows, Linux, Python)
- `17-documentation-ste` — Simplified Technical English for `DEPLOYMENT-*.md`

## Skills — `/name`

| Skill | Invoked by | Modes |
|---|---|---|
| `/review-lens` | you | infra · teamlead · architect · blindspot · sidebiz · community |
| `/challenge` | you | challenge · premortem · steelman · tradeoff · breakit |
| `/security-review` | **you or Claude** | — |
| `/userdocs` | you | — |
| `/jira` | you | — |
| `/plainify` | you | names · comments · both |

`security-review` is the only model-invocable skill: it should fire on its own when credential-shaped
work appears. Everything else is a deliberate invocation.

Not rebuilt here — already installed as Claude skills: terse-mode · context-compress · usage-stats ·
quick-reference · commit-message · code-review · session-summary (which owns `/eod`, `/pickup`, `/state`).

## Hooks — the one thing you would forget

Skills are what you reach for. A hook runs regardless of what you or the model decide. Only one
control needs that here; `01-me` and `00-project-context` already cover session state and review
habits without needing enforcement.

| Hook | Event | Does |
|---|---|---|
| `credential-guard` | PreToolUse `Edit\|Write` | Blocks literal secrets and PEM private keys. |

`credential-guard` replaces Continue's content-keyword `regex:` trigger on `11-security`. Continue
could only inject advice; a hook denies the write. It matches value-shaped secrets — keyword plus
assignment plus a 16-character value, or a PEM block — not bare keywords, which is what the
`11-security` context rule is for.

**Removed 2026-09-24** (Boris Cherny's rule: delete, use it, re-add only on repeat failure —
none did): `session-start` (redundant with `00-project-context`), `review-gate` (reminder only,
shipped two defects), `eod-reminder` (redundant with the `/eod` habit).

## Where things live — Notion vs this repo

| | Owns | Answers |
|---|---|---|
| **Notion** (Infrastructure Engineering → ⚙️ Clause-Skillz) | Intent, rationale, rejected options, `config.yaml` | **What and why** |
| **This repo** | Rule files, skills, hooks, scripts, `STATE.md` | **How — the working artifacts** |

Behavior questions resolve against the files. Questions about *why* a rule exists, or what was
rejected on the way to it, resolve against Notion. If the same sentence is in both, delete it from
Notion.

Session summaries live in Notion (subpages of the ⚙️ Clause-Skillz hub), never as `SESSION-*.md` here.

`STATE.md` records what changed and why at the commit level. Notion holds the longer-form reasoning
that outlives any single change.

## Distribution

**None.** Personal scope by design — the install is a copy into `~/.claude/` on each machine.

The former `git subtree --prefix .continue/rules` mechanism is retired. It never worked: `subtree`
places the *repo root* at the prefix, so rules landed at `.continue/rules/.continue/rules/*.md`
where nothing looks for them, four frontmatter-less markdown files landed where rules were expected,
and `.continue/prompts/` was never distributed at all.

## Configuration

`config.yaml` is not in this repo — it holds endpoint URLs and key references, and lives in Notion
only. Claude Code needs no equivalent: personal scope means no shared config.

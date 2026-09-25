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

Then copy the tree in. **First install** (no `~/.claude/settings.json` yet):

```bash
cp -r claude/rules claude/skills claude/hooks claude/settings.json ~/.claude/
```

**Updates** — don't overwrite `settings.json`; it holds your own settings too. Swap only the `hooks` block:

```bash
cp -r claude/rules claude/skills claude/hooks ~/.claude/
cp ~/.claude/settings.json ~/.claude/settings.json.bak
jq --slurpfile r claude/settings.json '.hooks = $r[0].hooks' ~/.claude/settings.json.bak > ~/.claude/settings.json
```

If a hook was removed from the repo, delete its script from `~/.claude/hooks/` too — `cp` doesn't remove files.

### Work machine (Windows, managed settings)

Rules and skills only. Managed settings block user-level hooks, so skip `hooks/` and `settings.json` — no `jq` needed. PowerShell:

```powershell
git clone https://github.com/lastusrnameon3/Clause-Skillz.git "$HOME\Codebase\Clause-Skillz"
cd "$HOME\Codebase\Clause-Skillz"

# keep Claude files out of every work repo — reuse an existing excludes file if one is set
$ex = git config --global core.excludesfile
if (-not $ex) { $ex = "$HOME\.gitignore_global"; git config --global core.excludesfile $ex }
$have = if (Test-Path $ex) { Get-Content $ex } else { @() }
'.claude/','CLAUDE.md','CLAUDE.local.md' | Where-Object { $_ -notin $have } | Add-Content $ex

New-Item -ItemType Directory -Force "$HOME\.claude" | Out-Null
Copy-Item -Recurse -Force .\claude\rules, .\claude\skills "$HOME\.claude"
```

Verify: `/context` lists the 5 universal rules (if not, managed settings restrict instruction sources — user rules won't load); `/skills` lists 6; `git check-ignore -v CLAUDE.md` in a work repo names the excludes file. Update: `git pull`, rerun the `Copy-Item` line. If GitHub is blocked, ask IT — don't carry the files in another way.

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
| `/code-review` | you | — (replaces bundled `/code-review`) |
| `/commit-message` | you or Claude | — |
| `/session-summary` | you or Claude | `/eod` · `/pickup` — employer work stays local |
| `/project-init` | you or Claude | personal · code · employer |
| `/architect-builder` | you or Claude | j · u · d · g · e · quick — the J.U.D.G.E. build loop |
| `/terse-mode` | you or Claude | on · off |
| `/quick-reference` | you or Claude | — |

`security-review` fires on its own when credential-shaped work appears.

**This repo is the one source for all 13.** Account skills (claude.ai) only reach Claude Code in
sessions signed in with a claude.ai account; API-key / `apiKeyHelper` / Bedrock sessions — the
usual setup at work — get none. So the skills needed in the terminal live here, and any account
copy is uploaded from these files, not edited separately. Not ported: context-compress,
usage-stats, ste (not needed in the terminal).

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

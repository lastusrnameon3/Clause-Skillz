---
name: quick-reference
description: One-shot reference card listing the Clause-Skillz skills, rules, and hook, and how each is triggered. Does not change any mode. Trigger — "what commands do I have", "skill help", "list skills".
---

# Quick Reference

One-shot display — doesn't activate or change anything.

## Skills — you type `/name`

| Skill | Use |
|---|---|
| `/review-lens` | Review from one angle: infra · teamlead · architect · blindspot · sidebiz · community |
| `/challenge` | Pressure-test a decision: challenge · premortem · steelman · tradeoff · breakit |
| `/security-review` | Credential / cert / secret review — also fires on its own |
| `/code-review` | One-line-per-finding diff review with severity prefixes |
| `/commit-message` | Conventional Commits message from the diff — writes only, never commits |
| `/userdocs` | User-facing docs for non-scripting teammates |
| `/jira` | Session → Jira-ready card updates |
| `/plainify` | Plain names and comments |
| `/session-summary` | `/eod` writes the day's summary; `/pickup` resumes from it |
| `/project-init` | Scaffold a new project (personal, code, or employer) |
| `/architect-builder` | Build loop: slice spec → build → fresh-context judge → you ship / revise / stop |
| `/terse-mode` | Compressed replies on; "normal mode" turns it off |
| `/quick-reference` | This card |

## Rules — load automatically

- Every session: `00-project-context` · `01-me` · `02-thinking` · `03-writing` · `04-tool-delegation`
- When matching files are open: `10-code` · `11-security` · `12-git-workflow` · `13`–`16` deployment · `17-documentation-ste`

## Hook

- `credential-guard` blocks literal secrets and private keys in file writes. Mac only — managed settings at work block user hooks.

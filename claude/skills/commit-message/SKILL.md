---
name: commit-message
description: Generate a Conventional Commits message from the current diff. Use when asked to "write a commit message" or before committing. Writes the message only — never stages, commits, or amends.
---

Generate a commit message in Conventional Commits format from the current changes.

**Subject line:** `<type>(<scope>): <imperative summary>` — scope optional.
Types: feat, fix, refactor, perf, docs, test, chore, build, ci, style, revert.
Imperative mood: "add", "fix", "remove" — not "added", "adds". Aim for ≤50 chars, hard cap 72. No trailing period.

**Body:** Skip entirely when the subject is self-explanatory. Add a body only for: a non-obvious why, breaking changes, migration notes, or linked issues. Wrap at 72 chars. Reference issues at the end: `Closes #42`, `Refs #17`.

**Never include:** "This commit does X", "I", "we", "now", AI-attribution lines, emoji (unless project convention uses it).

**Auto-clarity override:** Always write a full body for breaking changes, security fixes, data migrations, and reverts. Future debuggers need the context.

Generate the message only. Do not run git commit, stage files, or amend anything.

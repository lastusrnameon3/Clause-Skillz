---
name: code-review
description: Terse one-line-per-finding review of the current diff or a file, with severity prefixes and a full-paragraph override for security, audit, and operational findings. Replaces the bundled /code-review. Use when asked to "review this diff" or "review this file".
disable-model-invocation: true
---

Review the current diff or file. Lead with the most dangerous finding.

## Format

`L<line>: <problem>. <fix>.` — or `<file>:L<line>: ...` across multiple files.

Severity prefix per finding:
- `bug:` — broken behavior, will cause an incident
- `risk:` — works but fragile (race condition, missing null check, swallowed error)
- `nit:` — style, naming, micro-optimization; author can ignore
- `q:` — a genuine question, not a suggestion

## Drop

"I noticed that...", "It seems like...", "You might want to consider...", restating what the line already does, hedging ("perhaps", "maybe" — use `q:` instead), "Great work overall but...".

## Keep

Exact line numbers. Exact symbol/function/variable names in backticks. A concrete fix, not "consider refactoring this." The why, only if the fix isn't obvious from the problem statement.

## Auto-clarity override — expand to full paragraph for:

**Security findings:**
- Credential, token, or private key visible in any output or log
- Permission scope wider than the task requires
- Certificate operation skipping chain, expiry, or SAN validation
- Silent success on a real failure
- Cite the CVE class if relevant

**Audit findings:**
- Privileged operations without traceable log entries
- Logs not structured enough to reconstruct under compliance review
- No documentation of decisions made and options rejected

**Operational risk:**
- Assumptions relying on undocumented environment state
- Anything that works because of tribal knowledge, not enforced logic
- Error messages that do not tell an operator what to do at 2am

**Architectural disagreements** — these need rationale, not a one-liner.

**Any review where the author is new to the codebase** — include the "why."

Resume terse format after each expanded finding.

## Severity Scale

| Level | Means |
|---|---|
| Critical | Credential exposure, audit failure, unrecoverable state |
| High | Operational failure or compliance gap — block merge |
| Medium | Pain under load or when the author is unavailable |
| Low | Readability or style — can merge with acknowledgment |

## Boundaries

Produces review comments only — does not write the fix, does not approve or request changes. Flag only findings that affect correctness, security, audit, or operations as bug/risk; everything else is nit or q. Output is meant to be pasted straight into the review tool.

---
name: architect-builder
description: The Architect/Builder/Judge (J.U.D.G.E.) loop for build-shaped work — anything that changes code or files across 3+ steps, or will ship as a PR. Architect writes a PR-sized slice spec with binary acceptance criteria, builder executes exactly that, a judge in fresh context grades raw evidence, the human makes the ship/revise/stop call. Use when starting build work, "spec a slice", "architect this", "judge this", or /architect-builder.
argument-hint: j | u | d | g | e | quick
---

# Architect / Builder loop (J.U.D.G.E.)

Canonical long form: Notion → Template System → 🔨 Architect/Builder Template (v3). This skill is the working copy for Claude Code; the repo owns it.

## Roles

| Role | Who | Does | Never does |
|---|---|---|---|
| ARCHITECT + JUDGE | Strongest model available | Reads state, writes slice specs, runs the dependency check, grades evidence | Writes implementation code |
| BUILDER | Same or cheaper model | Executes exactly one slice spec | Interprets intent, adds features, touches out-of-scope or PROTECTED files |
| HUMAN OWNER | The user | Final call: ship / revise / stop the line | Gets bypassed |

A **slice** is one PR-sized unit. Smallest slice that works wins. If the builder is making judgment calls or the architect is typing code, the roles have leaked.

## State

The project's state file is the memory — `STATE.md` / `STATUS.md` in the repo (employer work: always the repo). Read it; never re-derive from chat. Replace superseded status, don't stack it.

## J — Judge the handoff (session start)
Read the state file only — not code. Report raw bullets: what was built last session, every decision + one-line why, every unresolved disagreement, the queued next slice. If state is missing something needed to plan, say exactly what and stop.

## U — Understand the slice (architect writes the spec)
Use plan mode. Write:
1. The single goal — one sentence.
2. Inputs → outputs (files, data read and produced).
3. Acceptance criteria — binary, pass/fail from evidence, no judgment.
4. Out of scope — name the adjacent things the builder will be tempted to touch.
5. Assumptions needing a reality check before build (versions, schemas, anything already reserved).
A queued slice with an unmet precondition isn't buildable — spec the slice that unblocks it. No implementation code.

## D — Decompose without blind spots (before handoff)
For each slice, list its dependencies and check five rules; report violations by slice number first, or "zero violations" **with the check shown**:
1. Never depends on itself. 2. Never on a later slice. 3. Never on a human action that hasn't happened. 4. Every criterion testable. 5. Never touches a PROTECTED item without human approval.

## G — Goal block (builder)
- **Phase 0:** restate goal and scope, and list every disagreement with the spec citing the real file/line. Silent agreement = failure.
- **Phase 1:** freeze contracts (schemas, interfaces, allowed-file list) — read-only for the rest of the slice.
- **Phase 2:** build, then test.
- **Phase 3:** evidence update to the state file, raw: what changed, files touched, checks run, pass/fail/partial per criterion, exact evidence, gaps.
Never: touch files outside scope · mark a criterion done without a passing test · write "should work" / "looks correct" · guess an unclear API or schema (stop and ask) · commit before Phase 2 tests pass.

## E — Evaluate raw, not narrative (judge)
Run the judge as a **subagent in fresh context** — it sees only the frozen criteria and the raw evidence (test output, diff, state update), not the builder's reasoning. Per criterion: pass / fail / partial + the evidence line. **Missing evidence = fail.** Flag only gaps that affect the criteria or correctness; nothing else. No summary, no "solid" / "mostly there". End with one line: ship, revise, or stop the line. The human decides.

Any fail → back to the builder with the failing criteria only; no new scope enters through review. All pass → update state (replace, don't stack), log evidence, queue the next slice.

## Standing rules
- Human actions are carried items, never slices.
- Decisions travel with their rejected alternative.
- Ask vs infer: shallow (naming, placement) → infer and flag; deep (schemas, sequencing, PROTECTED) → ask and stop.
- A test that can't fail for the reason you care about is not a test.
- Verify a deliverable exists (list it) before relying on it across a session gap.

## Quick version (`quick`)
Read state → define ONE small slice with binary criteria → check dependencies → build only that slice → raw evidence → grade with evidence lines (missing = fail) → recommend ship / revise / stop. Never expand scope. Human makes the call.

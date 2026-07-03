---
name: loop-verifier
description: Verify agent work against project gates before declaring it done. Use this skill whenever working in a project with a .loop/GATES.md file, whenever finishing any coding task inside a loop, whenever the user asks "is this actually done", "verify this", "check your work", or before emitting any VERDICT line. Also use it when a task involves tests, refactors, bug fixes, or dependency updates, when deciding whether work should be escalated to a human, and when the user asks to "audit my loop", "check loop readiness", or evaluate their loop setup.
---

# Loop Verifier

The checker half of the maker/checker split. Turns "the agent says it's done"
into "the gates say it's done." Built on one anti-cheating rule from the
research: checks must be derived from the TASK, before or independently of the
implementation — an agent that writes its checks after coding tends to write
checks that mirror its own mistakes.

## The protocol

### 1. Before implementing: write the checks

From the task description and `.loop/GATES.md`, produce the concrete check
list for this task:

- Which universal gates apply (they all do) and what they mean *here*
- Which task-type gates apply (code / bug fix / refactor / docs / dependency)
- The project-specific commands (build, test, lint) that must exit clean
- 3–5 task-specific checks: edge cases, invariants, a worked example with a
  known expected result

Write this list down BEFORE writing any implementation. This ordering is the
whole defense against self-confirming verification.

### 2. After implementing: run the gates

- Execute every runnable check for real (tests, build, lint). Paste actual
  output, not a summary of expected output.
- For non-runnable checks, walk each one explicitly: state the check, quote
  the evidence from the work, mark pass/fail.
- The Decompose audit is always included: every requirement in the task gets
  a quote from the output that satisfies it. No quote = gap = fail.

### 3. Verdict rules

- **PASS** requires: all applicable gates green, all checks walked, no check
  skipped silently.
- **FAIL** must name which gate failed and why — that line feeds the retry.
- A check you couldn't run (missing env, no test framework) is reported as
  UNRUN, and UNRUN on a required gate means the verdict is FAIL, not PASS.
  Unverifiable is not verified.
- Never soften a verdict because effort was high. The verdict describes the
  work, not the attempt.

### 4. Escalation triggers (hand to the human immediately)

- Any action on the GATES.md "Never" list would be required to proceed
- The same gate has failed 3 times for the same root cause
- The task requires changing the gates themselves
- Trust level is L1 and the fix requires applying changes

## Verifying by task type

**Code change** — new behavior gets a new test; run suite before and after;
Verify Loop on edge cases (empty input, boundary values, mutation of caller
data, error paths).

**Bug fix** — reproduce first. A fix without a reproduction is a guess. The
proof is one test that failed before the fix and passes after.

**Refactor** — the only gate that matters: identical behavior. Suite green
before AND after; public contracts untouched; if no tests exist, write
characterization tests first or escalate.

**Docs/writing** — every factual claim about the code checked against the
code. Then the Stranger Review pass from the loop-engineering skill.

**Dependency update** — read the changelog for breaking changes before
updating, not after the build breaks.

## Loop setup audit ("audit my loop")

When the user asks to audit their loop setup or loop readiness, score the
project against this checklist and report gaps with concrete fixes:

1. **Brain present:** `.loop/GATES.md`, `LESSONS.md`, `STATE.md` exist and
   aren't untouched templates (project-specific gates filled in?)
2. **Gates executable:** build/test/lint commands defined and actually run
   in this environment
3. **Trust level sane:** L2+ only with a populated LESSONS.md showing clean
   history; flag L3 without an allowlist as a finding
4. **Memory alive:** lessons being both written AND applied (standing rules
   present after 2+ weeks of use is the health signal); flag files past ~30
   entries for compression
5. **Stop rules:** max attempts set; escalation triggers reachable; "Never"
   list intact
6. **No sprawl:** if multiple loops run, check they share STATE.md's
   "Do not touch" list and don't overlap targets

Output: a short scorecard (each item pass/gap/fix), worst gap first. This
replaces a standalone audit CLI — the checklist is the tool.

## Maker/checker note

This skill is strongest when the checker runs in a separate context from the
maker (a fresh subagent, or at minimum a hard persona break) — models judge
their own work leniently and other work accurately. See
`docs/maker-checker.md` in the repo for the split recipes.

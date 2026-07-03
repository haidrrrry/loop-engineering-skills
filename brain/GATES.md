# GATES — what "done" means in this project

The agent may not declare a task finished until every applicable gate passes.
Gates are checked with checks written BEFORE implementation (see the
loop-verifier skill). "Looks correct" is not a gate.

## Trust level

Current level: **L1**

- **L1 — report-only.** Agent proposes changes and shows diffs; a human applies them. Start every new project here.
- **L2 — assisted.** Agent applies changes but may not commit; human reviews and commits.
- **L3 — unattended.** Agent commits routine changes matching an allowlist below. Earn this only after weeks of clean L2 history.

Raise the level by editing this line. The loop reads it every cycle.

## Universal gates (every task)

| Gate | Check |
|---|---|
| Scope | Every requirement in the task has quotable evidence in the output (Decompose audit) |
| No silent breakage | Existing tests still pass; existing behavior unchanged unless the task says otherwise |
| Checks-first | Verification criteria were written before implementation, not after |
| Honest verdict | Any failed or skipped check is reported, never hidden |

## Task-type gates

| Task type | Required gates |
|---|---|
| Code change | Run the test suite; add a test for the new behavior; run the Verify Loop on edge cases |
| Bug fix | Reproduce the bug first; prove the fix with a failing-then-passing test |
| Refactor | Behavior-identical: test suite green before AND after; no API contract changes |
| Docs/writing | Stranger Review Loop; every factual claim checked against the codebase |
| Dependency update | Changelog reviewed for breaking changes; tests green; patch/minor only at L1–L2 |

## Never (any trust level)

- Force-push, history rewrite, or deleting branches
- Committing secrets, keys, or .env contents
- Touching production configs or CI credentials
- Writing tests that merely mirror the implementation's assumptions —
  tests must come from the task's requirements (anti-cheating rule)

## Project-specific gates (edit me)

- [ ] Add your build command here (e.g. `npm run build` must exit 0)
- [ ] Add your test command here (e.g. `npm test` must pass)
- [ ] Add your lint command here

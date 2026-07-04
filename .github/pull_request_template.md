# What this changes

(one paragraph)

## Decompose audit (required — the repo eats its own dogfood)

Per CONTRIBUTING.md: quote which requirement of CONTRIBUTING.md each part of
this PR satisfies.

| Part of this PR | CONTRIBUTING requirement it satisfies (quoted) |
|---|---|
|  |  |

## Checks

- [ ] `bash tests/run-tests.sh` passes locally
- [ ] New loop (if any) has an external anchor and a stop condition
- [ ] New pattern (if any) specifies gates, what memory learns, escalation triggers
- [ ] No new code dependencies (markdown + bash only)
- [ ] Anti-cheating rules in loop-verifier untouched (or this PR is rejected)

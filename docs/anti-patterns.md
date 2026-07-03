# Anti-patterns — how loops go wrong

Each of these is observed in the wild, and several are documented in research.
The fix is built into this repo's design; this doc exists so you recognize
the failure when you see it anyway.

## 1. The naive self-check ("double-check your answer")

Asking a model to review its own output with no external reference. Research
(Huang et al., ICLR 2024) shows this *degrades* accuracy on reasoning tasks —
models flip correct answers to wrong ones more often than they find real
errors. **Fix:** every loop anchors to something outside the answer — tests,
a rubric written first, a spec, a persona shift. If there's no anchor, don't
loop.

## 2. The circular evaluator

An evaluator-optimizer loop where the evaluator can't actually distinguish
good from bad, so generator and evaluator orbit each other producing
confident nonsense. **Fix:** gates must be concrete and, wherever possible,
executable. "The evaluator feels it's good" is not a gate.

## 3. The cheating loop

The agent writes tests after (and from) its own implementation, so the tests
inherit its mistakes and everything is green. Documented by practitioners as
one of the sneakiest agent failures. **Fix:** the checks-first rule in
loop-verifier — verification criteria come from the TASK, written before
implementation. Deleting or weakening a test to reach green is an automatic
FAIL.

## 4. Memory theater

A LESSONS.md that gets written but never read. All cost, no learning.
**Fix:** the read step is mandatory and comes first in the protocol; the
runner's prompt enforces it every cycle.

## 5. The immortal lesson

Memory that only grows. 200 entries nobody reads is dead weight that also
bloats every prompt. **Fix:** compression protocol — recurring lessons
graduate to standing rules, old entries get deleted.

## 6. Over-looping

Iterating past the stop signal. When a critique pass returns only trivia,
the work is done; further "polish" passes are where correct things get broken.
**Fix:** hard cap of 2 revision passes unless an executable check is failing;
"only trivial findings" is defined as a stop condition, not an invitation.

## 7. Trust-level skipping

Giving a brand-new loop write or commit access because the demo looked good.
The first week of any loop is when its blind spots surface — that week must
be report-only. **Fix:** L1 → L2 → L3 ladder in GATES.md; promotion is a
human edit, never automatic.

## 8. The silent gate skip

"Test framework wasn't configured, so I proceeded" — an unrun check quietly
treated as a passed check. **Fix:** UNRUN on a required gate = FAIL. The
verdict rules make unverifiable mean unverified.

## 9. Loop sprawl

Running six loops before one has earned trust. Multiple immature loops also
collide (two loops editing the same files). **Fix:** one loop at a time until
it's boring. STATE.md's "Do not touch" list is shared by all loops.

## 10. The escalation-free loop

A loop with no path to a human is a loop that will eventually do its worst
work unsupervised. **Fix:** every pattern defines escalation triggers; the
runner escalates on attempt exhaustion by design; GATES.md's "Never" list is
non-negotiable at every trust level.

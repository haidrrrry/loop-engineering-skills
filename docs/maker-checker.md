# Maker / checker — splitting generator from verifier

Models judge their own work leniently and other work accurately (self-bias,
Xu et al. 2024; the self-correction blind spot, Tsui 2025). The more
separation between the maker and the checker, the more honest the verdict.
Three recipes, in ascending strength — use the strongest your setup allows.

## Recipe 1: persona break (works everywhere, weakest)

Same conversation, hard context shift. After the maker output:

```
Stop. New role: you are the reviewing engineer who has never seen this task
solved. The work above was submitted by a contractor. Your job depends on
finding what's wrong with it before it ships. Run the checks in GATES.md
against it. You gain nothing from it passing.
```

Weakness: same context window, so the maker's reasoning leaks into the
checker. Better than nothing; not better than the next two.

## Recipe 2: fresh session (works in any chat AI, medium)

Run the checker in a NEW conversation with no maker context. Paste only:
the task, the gates, and the work product — never the maker's explanation
of why the work is correct. The checker sees what a real reviewer sees:
requirements and artifact.

This exploits the blind-spot finding directly — with no memory of producing
the work, the model reviews it as external input, where its error-detection
actually functions.

## Recipe 3: checker subagent (Claude Code, strongest)

The maker runs as the main agent; verification dispatches to a subagent with
a clean context:

```
Use a subagent for verification. Give it ONLY: (1) the original task text,
(2) .loop/GATES.md, (3) the diff/artifact. Its instruction: derive the
checks from the task, run every executable gate, walk every non-executable
one with quoted evidence, and return VERDICT: PASS or FAIL with reasons.
It must not receive the implementation rationale.
```

Rules that keep the split honest, all recipes:

- The checker never receives the maker's self-assessment. "I tested this and
  it works" is contamination.
- The maker never grades its own verdict appeal. If the maker disputes a
  FAIL, the dispute goes to the human or a second checker, not back to the
  same checker with persuasion.
- Checks still come from the task, checker-side. A checker that asks the
  maker "what should I test?" has been captured.

## Cost note

Recipe 3 roughly doubles tokens per cycle. Spend it where verdicts matter:
CI sweeper and anything at trust level L2+. The changelog drafter doesn't
need a subagent checker; your money is better spent on the loops that can
break things.

# Research Notes: Why These Rules Exist

This skill's design choices come from published research on LLM
self-correction. Short version: iteration helps, but only when anchored to
something external. Naive "double-check your answer" prompting is the weakest
form and can make answers worse.

## What supports looping

**Self-Refine (Madaan et al., 2023).** The foundational generate → feedback →
refine framework. A single LLM plays generator, critic, and refiner in
sequence. Reported roughly 20% average improvement across tasks like dialogue,
code optimization, and math reasoning. Key mechanics the skill inherits:
feedback must be concrete and actionable, and prior versions plus feedback stay
in context so the model doesn't repeat mistakes.

**Execution-grounded refinement.** Work on LLM test generation and code repair
(e.g., Chat-Tester-style validate-and-fix pipelines) shows large reliability
gains when the loop feeds back *real* compiler/runtime/assertion errors rather
than the model's opinion of its own code. This is why the Verify Loop demands
actually running checks when an environment exists.

## What limits looping

**"Large Language Models Cannot Self-Correct Reasoning Yet" (Huang et al.,
Google DeepMind, ICLR 2024).** The critical result. With all external feedback
removed (no oracle labels, no tools), asking strong models to review and
correct their own reasoning on GSM8K and similar benchmarks *decreased*
accuracy. Models flipped correct answers to wrong ones more often than they
repaired real errors. The paper also showed that some earlier positive
self-correction results depended on oracle answer labels leaking into the loop
— remove the oracle and the improvement vanishes.

**Self-bias (Xu et al., 2024).** Models favor their own generated output when
judging quality, across tasks and languages. LLMRefine addressed this by using
a separate model as critic. In a single-model setting, the closest available
substitute is a hard persona/context shift — which is what the Stranger Review
Loop does.

**The self-correction blind spot (Tsui, 2025).** Models fail to correct errors
in their own output while successfully correcting the *identical* errors when
presented as external input. This directly motivates the Stranger Review
Loop's framing ("submitted by an unknown junior writer").

**Calibration problems.** LLM confidence is a poor proxy for correctness —
high confidence in wrong answers, occasional doubt about right ones. This is
why no loop in this skill uses "how confident are you?" as a signal, and why
rubrics must be written before the draft exists.

## Design consequences

| Research finding | Skill rule |
|---|---|
| Intrinsic self-correction degrades reasoning | Never loop without an anchor |
| Oracle-label leakage inflated old results | Anchors must be derivable from the task, not the answer |
| Execution feedback works | Verify Loop runs real checks when possible |
| Self-bias | Stranger Review persona shift; critique dimensions fixed in advance |
| Blind spot on own output | Treat drafts as third-party submissions |
| Poor calibration | Pre-committed rubrics; quotation-based audits in Decompose Loop |
| Diminishing/negative returns with iterations | Hard cap of 2 revision passes without a failing executable check |

## Honest caveats

- Most of the negative results are on *reasoning* benchmarks. Stylistic and
  structural revision (writing quality, coverage of requirements) degrades
  less and benefits more from iteration — but the anchor discipline still
  costs nothing and prevents drift.
- Multi-agent debate is not covered here; the DeepMind paper found it performs
  about on par with self-consistency at equal inference cost.
- Research moves fast. If a user cites newer work contradicting these notes,
  take it seriously and check it rather than defending the skill.

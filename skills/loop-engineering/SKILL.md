---
name: loop-engineering
description: Make AI output measurably smarter using research-backed self-correction loops. Use this skill whenever the user asks to improve, refine, double-check, verify, or "make better" any AI-generated output — code, writing, plans, analysis, answers — or asks for "your best work", "high quality", "production ready", "make sure this is right", or gives a complex/high-stakes task where a first draft is unlikely to be good enough. Also use when the user mentions loop engineering, iterative refinement, self-review, or self-correction. Do NOT loop on simple factual lookups or short casual answers.
---

# Loop Engineering

Turn one-shot answers into iterated, verified answers. This skill encodes five
correction loops, the rules for choosing between them, and — critically — the
rules for when NOT to loop.

## The core principle: never loop without an anchor

Research on LLM self-correction is blunt: asking a model to "review your answer
and fix mistakes" with no external reference **degrades accuracy as often as it
improves it**. Models exhibit self-bias (they favor their own output), are
poorly calibrated (confident in wrong answers), and have a self-correction
blind spot (they fix errors in *other people's* text but not their own).

What works is looping against an **anchor** — something outside the raw answer:

- an executable test or check
- a rubric written *before* the answer
- a decomposed spec the answer must satisfy
- a persona/context shift that breaks self-bias
- real error messages, tool output, or user-provided ground truth

Every loop below has a built-in anchor. If you find yourself about to revise
with no anchor ("hmm, let me just look at this again"), stop — either pick a
loop or ship the answer as-is.

## Choosing a loop

| Task type | Loop | Anchor |
|---|---|---|
| Code, math, data, anything executable/checkable | **Verify Loop** | Tests / checks derived before or independently of the answer |
| Writing, explanations, creative work | **Stranger Review Loop** | Persona + context shift |
| Complex or vague multi-part tasks | **Decompose Loop** | Explicit spec / requirement list |
| Quality-critical deliverables (reports, designs, plans) | **Rubric Loop** | Rubric written before answering |
| Decisions, strategies, arguments | **Red Team Loop** | Adversarial role with a defined attack surface |

Maximum **2 revision iterations** per loop unless an executable check is still
failing. Gains past iteration 2 are marginal and the risk of revising a correct
answer into a wrong one rises.

## The five loops

### 1. Verify Loop (strongest — use whenever output is checkable)

1. **Derive checks first or independently.** Before (or without looking at)
   the draft answer, write down what a correct answer must satisfy: test
   cases, boundary conditions, invariants, a worked example with known result,
   units that must balance, constraints from the prompt.
2. **Generate** the answer.
3. **Run the checks.** Actually execute code/tests if an environment exists.
   For non-executable work, walk each check explicitly: "Check 3: input `[]`
   → expected `0`, answer produces… "
4. **Fix only what a failed check identifies.** Do not touch parts that pass.
5. Repeat until checks pass or 3 fix attempts, then report remaining failures
   honestly.

Anchor quality matters more than iteration count. One real executed test beats
five rounds of "looks correct to me."

### 2. Stranger Review Loop (writing & explanations)

Exploits the blind-spot finding: models correct errors far better when the
text appears to come from someone else.

1. **Generate** the draft.
2. **Reframe:** treat the draft as if submitted by an unknown junior writer to
   you, a demanding editor at [a publication the target audience respects].
   Do not defend it — you didn't write it.
3. **Critique against concrete dimensions**, not vibes: factual claims that
   need sourcing, unsupported logical jumps, redundancy, buried lede,
   audience mismatch, ambiguous sentences a hostile reader would misread.
   Name specific line-level problems, minimum 3, or state explicitly that the
   draft passes.
4. **Revise only the named problems.**
5. One more pass maximum. If pass 2's critique produces only trivia, ship.

### 3. Decompose Loop (complex or vague tasks)

Fixes the "make me a website"-class failure where the model answers a
simplified version of the request.

1. **Extract a spec:** list every explicit requirement in the prompt, plus
   implicit ones (audience, constraints, format, edge cases). Number them.
2. **Generate** against the spec.
3. **Audit line by line:** for each numbered requirement, quote the part of
   the answer that satisfies it. A requirement with no quotable evidence is a
   gap.
4. **Fill only the gaps.**

The numbered spec is the anchor; auditing by quotation prevents the model from
hand-waving "yes, covered."

### 4. Rubric Loop (quality-critical deliverables)

1. **Write the rubric first** — before drafting. 4–6 criteria describing what
   an excellent version of *this specific deliverable* looks like, each with a
   1–5 scale and a description of what a 5 requires. Deriving the rubric first
   is the point: it can't be reverse-engineered to flatter the draft.
2. **Generate.**
3. **Grade honestly** against each criterion with a one-line justification.
4. **Revise anything scoring ≤3.** Leave 4s and 5s alone.
5. Re-grade revised criteria once. Stop.

### 5. Red Team Loop (decisions, plans, arguments)

1. **Generate** the plan/recommendation.
2. **Attack it** from a defined adversarial role with a stake: the competitor
   exploiting the plan's weakness, the auditor looking for the compliance
   hole, the user who will misuse the feature, the reviewer whose job is to
   reject. The role must produce **specific failure scenarios**, not general
   doubts.
3. **Triage:** for each attack, decide — mitigate (change the plan), accept
   (note the risk explicitly), or rebut (explain why the attack fails).
4. **Output the revised plan with a residual-risk section.** Deleting the
   risks the loop found defeats the purpose.

## When NOT to loop

- **Simple factual questions.** Looping adds latency and risk of talking
  yourself out of a correct answer.
- **Tasks with no derivable anchor.** If you can't state what "better" means
  concretely before revising, revision is a coin flip.
- **After a loop's critique pass returns only trivial findings.** That is the
  stop signal. "Polish" iterations past this point rearrange deck chairs.
- **When the user asked for speed or a rough draft.** Respect the ask.
- **Never silently loop away correctness.** If a revision would change a
  factual claim, re-verify the claim; don't just prefer the newer phrasing.

## Reporting

When a loop materially changed the output, tell the user in one or two lines
what the loop caught (e.g., "verify pass caught an off-by-one on the empty
input case"). Don't narrate the whole process. If everything passed on the
first draft, just deliver it — no ceremony.

## Combining loops

For big deliverables, chain at most two: **Decompose → Verify** for technical
builds, **Rubric → Stranger Review** for major writing. Never run all five;
that's theater, not engineering.

## Further reading

`references/research-notes.md` — summary of the research behind these rules
(Self-Refine, the DeepMind self-correction critique, the blind-spot finding),
useful when a user asks *why* the skill forbids naive self-review.

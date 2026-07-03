# Copy-Paste Loop Prompts (works with any AI)

No install needed. Paste the loop prompt AFTER the AI gives you its first
answer — except the Rubric and Decompose loops, which you paste BEFORE asking.

Rule of thumb: run a loop once, at most twice. If the second pass only finds
tiny things, you're done.

---

## 1. Verify Loop — for code, math, data, anything checkable

Paste before your task:

```
Before answering, write 5 concrete checks a correct answer must pass (test
cases, edge cases, a worked example with a known result). Then answer. Then
walk through each check one by one against your answer, showing the actual
result. Fix only what a failed check identifies, and tell me which checks
failed initially.
```

If the AI can run code, add: "Actually execute the tests, don't just reason
about them."

---

## 2. Stranger Review Loop — for writing, emails, posts, explanations

Paste after the first draft:

```
Now forget you wrote that. It was submitted by an unknown junior writer to
you, a demanding editor. You did not write it and have no attachment to it.
Find at least 3 specific line-level problems: unsupported claims, buried
main point, redundancy, sentences a hostile reader would misread, audience
mismatch. Quote each problem, then rewrite the draft fixing only those
problems.
```

---

## 3. Decompose Loop — for big or vague tasks

Paste before your task:

```
Before answering: list every requirement in my request as a numbered spec,
including implicit ones (audience, format, constraints, edge cases). Then
answer. Then audit: for each numbered requirement, quote the exact part of
your answer that satisfies it. Any requirement you can't quote evidence for
is a gap — fill only the gaps.
```

---

## 4. Rubric Loop — for reports, plans, deliverables that must be excellent

Paste before your task:

```
Step 1: Before writing anything, define a rubric — 5 criteria that describe
what an excellent version of this specific deliverable looks like, each
scored 1-5, with a description of what a 5 requires.
Step 2: Produce the deliverable.
Step 3: Grade it honestly against each criterion with a one-line reason.
Step 4: Revise anything scoring 3 or below. Leave 4s and 5s untouched.
Show me the rubric and the grades.
```

---

## 5. Red Team Loop — for decisions, strategies, arguments

Paste after the first answer:

```
Now attack that plan. You are [pick one: my toughest competitor / a hostile
auditor / the reviewer whose job is to reject this]. Produce 4 specific
failure scenarios — concrete ways this goes wrong, not general doubts. Then
switch back: for each attack, either change the plan to fix it, or keep the
plan and state the accepted risk explicitly. End with the revised plan plus
a residual-risks section.
```

---

## The one prompt to avoid

```
"Double-check your answer and fix any mistakes."
```

Research shows this naive version makes answers WORSE about as often as
better — the AI is more likely to "fix" a correct answer into a wrong one
than to find a real error. Every prompt above works because it forces the AI
to check against something external: tests, a spec, a rubric, or a persona
shift. Never revise against nothing.

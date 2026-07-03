# Loop picker — which loop do I use?

First, the anatomy every loop shares:

```
TRIGGER ──> ACTOR ──> VERIFIER ──> pass? ──> done (or human review)
(schedule,  (agent     (gates,        │
 event,      does       checks)       └─ fail ──> MEMORY ──> retry
 or you)     work)                              (lesson    (until STOP RULE:
                                                 written,    max attempts or
                                                 read next    escalation)
                                                 cycle)
```

Five parts: a trigger starts a cycle, an actor works, a verifier decides
pass/fail against gates, memory carries lessons between cycles, and a stop
rule ends it or hands off to a human. This repo supplies the verifier, the
memory, and the stop rules — the brain. Triggers and actors are your
scheduler and your agent.

Two levels exist in this repo. Answer one question first:

**Are you improving a single answer, or automating a recurring job?**

## Improving a single answer → answer loops (loop-engineering skill)

| Your situation | Loop | Why |
|---|---|---|
| Code, math, data — anything with a checkable right answer | **Verify** | Checks written before the answer catch what re-reading never will |
| Writing that has to land — email, post, docs | **Stranger Review** | The model critiques "someone else's" draft far better than its own |
| Big vague ask ("build me X") | **Decompose** | Numbered spec + quote-audit stops the model answering a simpler question |
| A deliverable that must be excellent | **Rubric** | Rubric-first prevents grade inflation |
| A plan or decision | **Red Team** | A named adversary finds the failure the optimist missed |

Copy-paste versions for any AI: `prompts/copy-paste-loops.md`.

## Automating a recurring job → system loops (`docs/patterns.md` + runner)

| Your situation | Pattern | First trust level |
|---|---|---|
| "What needs my attention today?" | Daily triage | L1 |
| Release notes are always late | Changelog drafter | L1 |
| PRs sit waiting on review responses | PR babysitter | L1, important PRs only |
| CI keeps going red | CI sweeper | L1, strictest gates |
| Dependencies rot | Dependency sweeper | L1, patch/minor |
| Repo hygiene debt | Post-merge cleanup | L1 |

## Both at once (the normal case)

System loops *contain* answer loops: the pattern is the body, the answer
loops run inside its verify step. The runner wires this automatically — the
loop-verifier skill picks the right answer loop per task type.

## Neither

- One-off simple question → just ask, no loop. Loops on trivial tasks add
  cost and can talk a correct answer into a wrong one.
- Task where you can't define "done" → you're not ready to loop; write the
  gate first. A loop without a real gate automates garbage.

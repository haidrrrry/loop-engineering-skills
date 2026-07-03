# Contributing

## What's wanted

**New answer loops** — add one to the `loop-engineering` skill. Required:
- An external anchor (tests, spec, rubric written first, persona shift). No anchor = no loop. This is the repo's core rule; see `docs/anti-patterns.md` §1.
- A concrete stop condition. "Looks good" is not a stop condition.

**New system-loop patterns** — add to `docs/patterns.md`. Required:
- Gates: what must be true before the loop acts.
- What memory learns: what goes into LESSONS.md and when.
- Escalation triggers: when the loop stops and asks a human.

**Model test reports** — ran the prompts in `prompts/copy-paste-loops.md` on GPT, Kimi, Gemini, or anything else? Open a PR with what worked, what didn't, and any changes that helped.

**Script fixes** — bugs in `install.sh` or `runner/loop.sh` are welcome. Keep bash portable (no bashisms beyond `#!/usr/bin/env bash`).

## What's not wanted

- Loops without an external anchor (see anti-pattern §1).
- Code dependencies. This repo is markdown + bash deliberately — no npm, no pip, no imports.
- Edits that weaken the anti-cheating rules in `skills/loop-verifier/SKILL.md` (checks-first rule, UNRUN = FAIL, no weakening a test to reach green).

## PR process

1. Fork, branch per change, one change per PR.
2. Run the repo's own **Decompose audit** on your contribution before submitting: break the change into its requirements and verify each part independently.
3. In your PR description, quote which requirement of this CONTRIBUTING file each part of your PR satisfies.

That's it. No CLA, no setup beyond bash and a Claude Code install to test locally.

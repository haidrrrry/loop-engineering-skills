---
name: loop-memory
description: Give the agent episodic memory so it improves every cycle instead of repeating mistakes. Use this skill whenever working in a project that has a .loop/LESSONS.md file, whenever a task is being retried after a failure, whenever the user says "remember this", "don't make that mistake again", "learn from this", or "why do you keep doing that", and at the start and end of every task run inside a loop. Also use it to compress or maintain the lessons file when it grows long.
---

# Loop Memory

Reflexion-style verbal memory: the agent reflects on each attempt in writing,
stores the reflection, and reads recent reflections before acting. Research
(Shinn et al., 2023) shows this mechanism — reflect, store, re-read — beats
blind retrying by wide margins (+22% on decision tasks over 12 trials, +11%
on code) and beats memory-without-reflection by 8 points. The gain comes from
*written reasons*, not from retrying harder.

## The protocol

### Before acting (every task)

1. Read `.loop/LESSONS.md`.
2. Apply the **Standing rules** section unconditionally.
3. Read the **3 most recent entries**. If any is relevant to the current
   task, state in one line how it changes your approach. If none is
   relevant, proceed — do not force it.

### After acting (every attempt, pass or fail)

Append exactly one entry in the file's format:

```
## [date] — [task, 5 words max] — PASS|FAIL
- What happened: [one line]
- Root cause / why it worked: [one line]
- Next time: [one specific, checkable instruction]
```

Quality bar for "Next time":
- ❌ "Be more careful with the database" — not checkable
- ✅ "Run `npx prisma migrate deploy` before any seed script" — checkable
- ❌ "Remember the API is tricky" — vague
- ✅ "The /users endpoint paginates at 50; always pass ?page= when counting"

### Failure reflection, specifically

When an attempt failed, the reflection must answer: what did I *believe* that
was wrong? Failed attempts usually come from a false assumption, not a typo.
Name the assumption. That's the lesson.

### Maintenance (when the file exceeds ~30 entries)

1. Read all entries oldest-first.
2. Any lesson that appears 2+ times graduates into **Standing rules**,
   rewritten as a single imperative line.
3. Delete the oldest 20 entries after graduation.
4. Never delete Standing rules without the user's approval.

## What NOT to store

- Secrets, keys, tokens, personal data — never, even if they caused the failure.
- Narration ("I then tried X, after which Y…") — store conclusions only.
- Duplicate lessons — if it's already there, don't re-add; consider graduating it.
- Blame or self-criticism — lessons are instructions, not feelings.

## Failure modes to avoid

- **Memory theater:** writing entries but never reading them. The read step
  is the value; the write step alone is a diary.
- **Overfitting to one incident:** a one-off environment hiccup is not a
  lesson. If it can't recur, don't record it.
- **Unbounded growth:** a 200-entry file no one reads is dead memory. Compress.

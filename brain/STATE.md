# STATE — durable memory outside any conversation

The loop reads this before acting and updates it after. It exists so cycles
never redo finished work and never lose track of blockers. Keep it current;
stale state is worse than no state.

## Current goal

(one sentence — what the loop is working toward right now)

## Done

- (completed items, newest first, one line each)

## In progress

- (item — and exactly where it stands)

## Blocked / needs human

- (item — what's blocking, what decision or access is needed)

## Do not touch

- (files, systems, or areas the agent must leave alone, with reason)

#!/usr/bin/env bash
# loop.sh — the loop: task -> act -> verify -> reflect -> retry or escalate.
# Requires Claude Code (`claude` CLI) installed and authenticated.
# Usage: .loop/bin/loop.sh "your task" [max_attempts]
set -uo pipefail

TASK="${1:?Usage: loop.sh \"task description\" [max_attempts]}"
MAX_ATTEMPTS="${2:-3}"
LOOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v claude >/dev/null 2>&1; then
  echo "ERROR: Claude Code CLI not found. Install it first: https://code.claude.com" >&2
  exit 1
fi

for f in GATES.md LESSONS.md STATE.md; do
  [ -f "$LOOP_DIR/$f" ] || { echo "ERROR: $LOOP_DIR/$f missing. Run install.sh first." >&2; exit 1; }
done

# Trust-aware permissions: only grant edit rights at L2+.
# At L1 the agent produces proposals and diffs — it does not modify files.
TRUST_LEVEL="$(grep -oE 'Current level: \*\*L[123]\*\*' "$LOOP_DIR/GATES.md" | grep -oE 'L[123]' || echo L1)"
PERM_ARGS=()
if [ "$TRUST_LEVEL" != "L1" ]; then
  PERM_ARGS=(--permission-mode acceptEdits)
fi
echo "==> Trust level: $TRUST_LEVEL $([ "$TRUST_LEVEL" = "L1" ] && echo '(report-only: agent proposes, you apply)')"

attempt=1
last_verdict=""

while [ "$attempt" -le "$MAX_ATTEMPTS" ]; do
  echo "==> Attempt $attempt/$MAX_ATTEMPTS: $TASK"

  # ACT + VERIFY + REFLECT happen inside one agent run, governed by the brain
  # files and the installed loop-* skills. The prompt enforces the contract.
  set +o pipefail
  claude -p "You are running inside a self-correcting loop (attempt $attempt of $MAX_ATTEMPTS).

TASK: $TASK

MANDATORY PROTOCOL:
1. Read .loop/LESSONS.md — apply the last 3 lessons to this attempt.
2. Read .loop/STATE.md — do not redo completed work; respect blockers.
3. Read .loop/GATES.md — identify which gates apply to this task, and WRITE
   THE CONCRETE CHECKS FIRST, before implementing anything.
4. Do the task.
5. VERIFY WITH A CLEAN-CONTEXT CHECKER: dispatch verification to a subagent
   (maker/checker recipe 3). Give it ONLY the original task text,
   .loop/GATES.md, and the diff/artifact — never your reasoning or
   self-assessment. It runs every applicable gate for real (executing
   tests/commands where possible) and returns its own verdict with evidence.
   If subagents are unavailable, perform a hard persona break and run the
   gates as a reviewer who has never seen this task solved.
6. Update .loop/STATE.md with what you completed or what blocked you.
7. Append ONE entry to .loop/LESSONS.md in the required format — even on
   success (note what worked).
8. End your reply with exactly one line, plain text, starting at column one,
   no markdown formatting: VERDICT: PASS or VERDICT: FAIL, followed by a
   one-line reason.
9. Trust level is $TRUST_LEVEL. At L1 you must NOT modify files — output
   proposed changes as diffs for the human to apply.

Previous attempt verdict, if any: ${last_verdict:-none}" \
    ${PERM_ARGS[@]+"${PERM_ARGS[@]}"} 2>&1 | tee "$LOOP_DIR/last-run.log"
  claude_status=${PIPESTATUS[0]}
  set -o pipefail

  # A CLI failure (auth, network, crash) is not a task failure — retrying
  # burns attempts on the same error. Stop and tell the human.
  if [ "$claude_status" -ne 0 ] && ! grep -qE '^[[:space:]]*\**VERDICT:' "$LOOP_DIR/last-run.log"; then
    echo "==> ERROR: claude exited with status $claude_status and emitted no verdict." >&2
    echo "    This looks like a CLI/auth/network problem, not a task failure." >&2
    echo "    Check .loop/last-run.log, fix the environment, and rerun." >&2
    exit 2
  fi

  # Only trust the LAST verdict line. The protocol text itself contains the
  # words "VERDICT: PASS", so matching anywhere in the log gives false passes.
  # Tolerate markdown decoration (bold, leading spaces) around the verdict,
  # then normalize it before matching.
  last_verdict="$(grep -E '^[[:space:]]*\**VERDICT:' "$LOOP_DIR/last-run.log" | tail -1 | sed -E 's/^[[:space:]]*\**//; s/\**[[:space:]]*$//' || true)"
  if [ -z "$last_verdict" ]; then
    last_verdict="VERDICT: FAIL (no verdict emitted)"
  fi

  case "$last_verdict" in
    "VERDICT: PASS"*)
      echo "==> PASS on attempt $attempt. Review the diff before you ship — the loop verifies, you decide."
      exit 0
      ;;
  esac

  echo "==> $last_verdict"
  attempt=$((attempt + 1))
done

echo ""
echo "==> ESCALATION: $MAX_ATTEMPTS attempts failed. The loop is handing off to you."
echo "    Context: .loop/last-run.log (full last attempt)"
echo "              .loop/LESSONS.md (what it learned and tried)"
echo "              .loop/STATE.md   (where it got stuck)"
exit 1

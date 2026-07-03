#!/usr/bin/env bash
# loop-engineering-skills installer
# Copies the brain files into your project and the skills into Claude Code.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${1:-$(pwd)}"

echo "Installing loop-engineering-skills into: $PROJECT_DIR"

# 1. Brain files (never overwrite an existing brain — it holds learned lessons)
mkdir -p "$PROJECT_DIR/.loop"
for f in LESSONS.md GATES.md STATE.md; do
  if [ -f "$PROJECT_DIR/.loop/$f" ]; then
    echo "  keep   .loop/$f (already exists — your agent's memory is preserved)"
  else
    cp "$REPO_DIR/brain/$f" "$PROJECT_DIR/.loop/$f"
    echo "  create .loop/$f"
  fi
done

# 2. Skills -> project-level Claude Code skills
mkdir -p "$PROJECT_DIR/.claude/skills"
for skill in loop-engineering loop-memory loop-verifier; do
  rm -rf "$PROJECT_DIR/.claude/skills/$skill"
  cp -r "$REPO_DIR/skills/$skill" "$PROJECT_DIR/.claude/skills/$skill"
  echo "  install skill: $skill"
done

# 3. Runner
mkdir -p "$PROJECT_DIR/.loop/bin"
cp "$REPO_DIR/runner/loop.sh" "$PROJECT_DIR/.loop/bin/loop.sh"
chmod +x "$PROJECT_DIR/.loop/bin/loop.sh"
echo "  install runner: .loop/bin/loop.sh"

echo ""
echo "Done. Try it:"
echo "  .loop/bin/loop.sh \"add input validation to the signup form\""
echo ""
echo "Your agent will now: act -> verify against .loop/GATES.md ->"
echo "record lessons in .loop/LESSONS.md -> retry on failure -> escalate to you when stuck."

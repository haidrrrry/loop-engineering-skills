#!/usr/bin/env bash
# Tests for the loop's own gates. Pure bash, no dependencies — the repo
# preaches checks-first, so it ships its own.
set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAILURES=0
TESTS=0

check() { # check "name" <command...>
  local name="$1"; shift
  TESTS=$((TESTS + 1))
  if "$@" >/dev/null 2>&1; then
    echo "PASS  $name"
  else
    echo "FAIL  $name"
    FAILURES=$((FAILURES + 1))
  fi
}

# Extract the verdict exactly the way loop.sh does, so the tests can't
# drift from the implementation.
parse_verdict() { # parse_verdict <logfile> -> echoes normalized last verdict
  grep -E '^[[:space:]]*\**VERDICT:' "$1" | tail -1 \
    | sed -E 's/^[[:space:]]*\**//; s/\**[[:space:]]*$//'
}

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

## 1. Script syntax
check "install.sh parses"            bash -n "$REPO_DIR/install.sh"
check "runner/loop.sh parses"        bash -n "$REPO_DIR/runner/loop.sh"

## 2. Verdict parsing — the false-PASS regression suite
printf 'End your reply with exactly one line: VERDICT: PASS or VERDICT: FAIL\nwork\nVERDICT: FAIL missing test\n' > "$TMP/protocol-echo.log"
v="$(parse_verdict "$TMP/protocol-echo.log")"
check "protocol echo does not fake a PASS" [ "${v#VERDICT: PASS}" = "$v" ]

printf 'work\nVERDICT: PASS all gates green\n' > "$TMP/clean-pass.log"
v="$(parse_verdict "$TMP/clean-pass.log")"
check "clean PASS is detected"       [ "${v#VERDICT: PASS}" != "$v" ]

printf 'work\n**VERDICT: PASS** all green\n' > "$TMP/bold-pass.log"
v="$(parse_verdict "$TMP/bold-pass.log")"
check "markdown-bold PASS is detected" [ "${v#VERDICT: PASS}" != "$v" ]

printf 'VERDICT: PASS early claim\nmore work\nVERDICT: FAIL gate 2 red\n' > "$TMP/late-fail.log"
v="$(parse_verdict "$TMP/late-fail.log")"
check "last verdict wins over earlier PASS" [ "${v#VERDICT: FAIL}" != "$v" ]

printf 'no verdict anywhere\n' > "$TMP/no-verdict.log"
v="$(parse_verdict "$TMP/no-verdict.log")"
check "missing verdict yields empty (treated as FAIL)" [ -z "$v" ]

## 3. Trust-level parsing — same grep as loop.sh
tl() { grep -oE 'Current level: \*\*L[123]\*\*' "$1" | grep -oE 'L[123]' || echo L1; }
printf 'Current level: **L2**\n' > "$TMP/gates-l2.md"
check "L2 is parsed from GATES.md"   [ "$(tl "$TMP/gates-l2.md")" = "L2" ]
printf 'no level line\n' > "$TMP/gates-none.md"
check "missing level defaults to L1" [ "$(tl "$TMP/gates-none.md")" = "L1" ]

## 4. Installer behavior
PROJ="$TMP/proj"
mkdir -p "$PROJ"
bash "$REPO_DIR/install.sh" "$PROJ" >/dev/null
check "installer creates brain files"    [ -f "$PROJ/.loop/GATES.md" ]
check "installer creates lessons"        [ -f "$PROJ/.loop/LESSONS.md" ]
check "installer creates state"          [ -f "$PROJ/.loop/STATE.md" ]
check "installer creates runner"         [ -x "$PROJ/.loop/bin/loop.sh" ]
check "installer creates loop gitignore" grep -q 'last-run.log' "$PROJ/.loop/.gitignore"
check "installer installs all 3 skills"  [ -f "$PROJ/.claude/skills/loop-verifier/SKILL.md" ]

# Idempotency: a second install must never overwrite learned memory.
echo "## learned lesson" >> "$PROJ/.loop/LESSONS.md"
bash "$REPO_DIR/install.sh" "$PROJ" >/dev/null
check "reinstall preserves LESSONS.md"   grep -q 'learned lesson' "$PROJ/.loop/LESSONS.md"

## 5. Runner guardrails
mkdir -p "$TMP/empty/.loop/bin"
cp "$REPO_DIR/runner/loop.sh" "$TMP/empty/.loop/bin/"
(cd "$TMP/empty" && bash .loop/bin/loop.sh "task" >/dev/null 2>&1) && rc=0 || rc=$?
check "runner refuses to run without brain files" [ "$rc" -ne 0 ]

bash "$REPO_DIR/runner/loop.sh" >/dev/null 2>&1 && rc=0 || rc=$?
check "runner requires a task argument" [ "$rc" -ne 0 ]

## 6. README links resolve
missing=0
while read -r f; do
  [ -e "$REPO_DIR/$f" ] || missing=$((missing + 1))
done < <(grep -oE '\]\(([^)#h][^)]*)\)' "$REPO_DIR/README.md" | sed 's/](\(.*\))/\1/')
check "all README relative links resolve" [ "$missing" -eq 0 ]

echo ""
echo "$((TESTS - FAILURES))/$TESTS passed"
[ "$FAILURES" -eq 0 ] || exit 1

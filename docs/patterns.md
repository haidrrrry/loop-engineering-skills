# Loop patterns — six system loops, brain included

Six proven loop shapes (pattern names from the loop-engineering literature —
Osmani, Cherny, Greyling), each rewritten here with the missing piece
specified: which gates verify it, what its memory learns, and when it hands
off to a human. Run any of them with `.loop/bin/loop.sh` or your own
scheduler.

Every pattern starts at trust level **L1 (report-only)** for at least a week.
The pattern earns L2 by producing clean reports; it never promotes itself —
you edit GATES.md when you're convinced.

---

## 1. Daily triage

**Cycle:** once a day. Scan open issues, failing checks, and TODOs; produce a
prioritized report of what deserves attention.

- **Gates:** report cites real evidence (issue links, failing test names) for
  every item; no item invented; Decompose audit against "what changed since
  yesterday".
- **Memory learns:** which priorities the human consistently reorders — after
  3 reorders of the same kind, the lesson graduates to a standing rule.
- **Escalate:** anything security-shaped goes to the top with a ping, never
  auto-handled.
- **Cost:** low. Safest first loop to run.

## 2. PR babysitter

**Cycle:** every 5–15 min while a PR is open. Watch reviews and CI; when a
reviewer comments or a check fails, prepare (L1) or apply (L2) the response.

- **Gates:** the reviewer's actual request is quoted and addressed
  point-by-point; CI green after changes; no changes beyond the review's
  scope.
- **Memory learns:** this reviewer's recurring standards ("always wants early
  returns") — graduates to standing rules per reviewer.
- **Escalate:** review comments that disagree with each other; requests that
  would violate GATES.md.
- **Cost:** high (frequent cycles). Run on important PRs, not all PRs.

## 3. CI sweeper

**Cycle:** on red CI. Reproduce the failure, diagnose, prepare or apply a fix.

- **Gates:** failure reproduced locally BEFORE any fix; the fix's proof is
  the exact failing test now passing; no test deleted or weakened to get to
  green (anti-cheating gate — this is the loop most tempted to cheat).
- **Memory learns:** flaky tests vs real failures; recurring breakage sources.
- **Escalate:** failure reproduces but cause is outside the repo (infra,
  secrets, external API); or 3 fix attempts failed.
- **Cost:** very high. The gates here must be the strictest.

## 4. Dependency sweeper

**Cycle:** daily or weekly. Check for dependency updates; apply patch/minor
per gates.

- **Gates:** changelog read for breaking changes before updating; suite green
  after; majors are report-only at every trust level below L3.
- **Memory learns:** which packages break things ("lib X minor bumps broke
  builds twice — treat as major").
- **Escalate:** any security advisory (report immediately regardless of
  cycle), any major version.
- **Cost:** medium.

## 5. Changelog drafter

**Cycle:** on tag or daily. Draft changelog entries from merged commits.

- **Gates:** every entry maps to a real commit (quotable hash); user-facing
  language, not commit-speak; Stranger Review pass before presenting.
- **Memory learns:** the project's changelog voice; which details maintainers
  add by hand.
- **Escalate:** never needs to — pure report loop. Best absolute first loop.
- **Cost:** low.

## 6. Post-merge cleanup

**Cycle:** daily, off-peak. After merges: stale branches, leftover TODOs,
docs drift.

- **Gates:** a branch is "stale" only if merged AND older than the threshold
  in GATES.md; docs changes quote the code they now describe; deletions are
  listed at L1 and only executed at L2+.
- **Memory learns:** which "stale" things turned out to be wanted (someone
  restored a branch → standing rule: never touch branches matching that
  pattern).
- **Escalate:** anything on the "Do not touch" list in STATE.md.
- **Cost:** low.

---

## Picking your first loop

Changelog drafter or daily triage. Both are report-only by nature, cheap, and
build your trust in the system before anything gets write access. The worst
first choice is the CI sweeper — highest cost, highest cheating temptation,
highest blast radius.

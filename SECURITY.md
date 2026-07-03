# Security

## Real risks in this repo

This project ships shell scripts (`install.sh`, `runner/loop.sh`) you execute,
and prompts that instruct an AI agent. The actual attack surface:

**Prompt injection via brain files.** LESSONS.md and GATES.md are trusted
input — the runner feeds them directly to the agent. A malicious edit to
either file can steer the agent. Don't install brain files from untrusted
sources. Treat them like config, not content.

**Runner permissions at L2+.** At trust level L2 and L3 the loop can edit
files without asking. The `GATES.md` "Never" list is the boundary. Never run
at L3 on a repo that contains secrets, credentials, or production config.

**Trust-level escalation.** Promoting a loop from L1 to L2 or L3 too early
is the most common unsafe use. The first runs of any loop are when its blind
spots surface. Promote only after it's been boring at the lower level.

## Hard rules

- The `GATES.md` "Never" list is non-negotiable at every trust level.
- PRs that weaken those rules will be rejected. No exceptions.
- UNRUN on a required gate means FAIL — never "probably fine."

## Reporting

For exploitable problems (prompt-injection bypass, script that can escalate
privileges, anything that could run unintended commands): open a
[GitHub Security Advisory](https://github.com/haidrrrry/loop-engineering-skills/security/advisories/new)
or use GitHub's private vulnerability reporting rather than a public issue.

Solo maintainer. Best-effort response — no SLA.

# Changelog

## Unreleased

- Routines (outside the plugin): `daily-ai-news` and `daily-news`, scheduled-task prompts for the Claude desktop app that post a morning digest to Slack through webhooks read from `~/.config/daily-news/webhooks.env`. Setup in [routines/README.md](routines/README.md).
- `/pg:new-command`: describe what a command should do; it proposes a name and its own paraphrase of the goal, waits for your approval, then writes the skill, updates the docs, runs the checks, commits on a branch and opens a pull request to `main`.
- `/pg:slack-triage`: reads the Slack messages an instruction points at (a person, a channel, a time range) and lists one item per issue: topic, the quoted fragment, a first analysis and the action for you. Read-only.
- `security.md` takes the OWASP Top 10:2025 and ASVS 5.0 as its baseline and maps every Top 10 category to its rules. New rules close the gaps: SEC-13 (fail closed), SEC-14 (abuse cases for a new trust boundary), SEC-40 (hardened configuration), SEC-41 (security events logged and alerted).
- `ai.md` maps the OWASP Top 10 for LLM Applications 2025 and the Top 10 for Agentic Applications 2026 to its rules. New rules: AI-04 (pinned model and tool sources), AI-12 (no secrets in system prompts), AI-24 (the user's permissions, scoped credentials), AI-25 (traceable index and memory content), AI-26 (sandboxed generated code), AI-27 (confirmations show the real action), AI-34 (agent tool calls logged, agent can be stopped); AI-31 also caps input size.
- `pg:reviewer` checks security and AI changes against those OWASP maps and cites the OWASP category next to the rule id.

After updating: a project's standards are its own copies, and `/pg:init` never overwrites them. Compare them with the new templates and take what applies.

## 0.2.0 (2026-11-01)

- Standards: `ai.md`, `privacy.md` (GDPR and AI Act), `performance.md` and `accessibility.md` (WCAG 2.2 AA), plus a `docs/data-inventory.md` template.
- `/pg:init` copies each new standard only when the project shows it needs it, lists what it skipped and why, and can be run again to add a missing one.
- `pg:reviewer` reads every file in `docs/standards/` and checks AI, privacy, performance and accessibility, citing their rule ids.

After updating: in a project set up with 0.1.0, run `/pg:init` again to add the standards that apply.

## 0.1.0 (2026-11-01)

First release of the `pg` plugin.

- Skills: `init`, `spec`, `plan`, `tdd`, `review`, `ship`, `quick`, `adr`.
- Agent: `reviewer`, read-only, fresh context.
- Hooks: `tdd-guard` and `format-on-edit`, active only where `.pg/` exists.
- Templates: workflow, backlog, ADR, feature spec/plan/review, baseline standards (general, testing, security).

# pg-toolkit

My Claude Code toolkit: the skills, agent and hooks I carry from project to project. It packages one way of working with a coding agent: the agent proposes and builds, the human approves at the spec, the plan, the review triage and the merge, and every behaviour change lands test-first, visible in git history.

## Requirements

- Claude Code with plugin support (`claude plugin --help` works).
- `git` and `jq` (the hooks read the tool call with `jq`; without it `tdd-guard` warns and does not protect tests).
- Optional: `gh` for `/pg:ship` and `/pg:new-command` to open pull requests; a connected Slack integration for `/pg:slack-triage`; the project's own formatters for `format-on-edit`.

## Install

From GitHub:

```bash
claude plugin marketplace add pg013c/pg-toolkit
claude plugin install pg@pg-toolkit
```

From a local clone. The plugin is read straight from the folder, so edits apply in the next new session:

```bash
claude plugin marketplace add <path to your clone>
claude plugin install pg@pg-toolkit
```

Check it: `claude plugin details pg@pg-toolkit` lists 11 skills, 1 agent and 2 hooks.

Update an install from GitHub: `claude plugin marketplace update pg-toolkit`, then `claude plugin update pg@pg-toolkit`. Remove: `claude plugin uninstall pg@pg-toolkit`.

## Quick start

In the repository you work on, start Claude Code and run:

1. `/pg:init` once. It asks before creating anything and never overwrites files. Use `/pg:init --minimal` for a take-home or live-coding task.
2. A feature: `/pg:spec <what it should do>` → approve → `/pg:plan F-01` → approve → `/pg:tdd F-01` once per step → `/pg:review F-01` → decide each finding → `/pg:tdd F-01 <finding>` for each `fix` → `/pg:ship F-01`.
3. A small fix or chore: `/pg:quick <what to change>`. If it is not small, it says so and suggests `/pg:spec`.

The human approves at four points: the spec, the plan, the review triage and the merge. Skills commit their own work after each approval; pushing and opening a pull request always waits for an explicit yes, and nothing is ever merged by the agent.

## What `/pg:init` adds to a project

```text
.pg/                       marker that turns the hooks on for this repository
.pg/state/                 TDD phase (gitignored)
.pg/test-paths             optional: your test globs, one per line, replacing the defaults
CLAUDE.md                  a "pg workflow" section: check command, test command, main branch
docs/workflow.md           the process
docs/backlog.md            features F-01, F-02, ... and their status
docs/adr/                  decision records and their index
docs/standards/            rules with ids the plan, the code and the review follow (below)
docs/data-inventory.md     personal data and processors, when privacy.md is copied
docs/features/_templates/  spec, plan and review templates
```

Standards, each rule with an id the reviewer cites:

| File | Ids | Copied when |
|---|---|---|
| `general.md` | `GEN-` | always |
| `testing.md` | `TEST-` | always |
| `security.md` | `SEC-` | always (mapped to the OWASP Top 10:2025 and ASVS 5.0) |
| `ai.md` | `AI-` | the project depends on a model SDK or calls a model API (mapped to the OWASP Top 10 for LLM and for Agentic Applications) |
| `privacy.md` | `PRIV-` | the project stores data about people (GDPR, plus the AI Act for AI features); asks when unsure |
| `performance.md` | `PERF-` | the project is a service or app with a server, database, jobs or UI |
| `accessibility.md` | `A11Y-` | the project has a web or mobile UI (WCAG 2.2 AA) |
| `<stack>.md` | your prefix | always, drafted from what the project already does |

`/pg:init` lists the files it skipped and why. Run it again later to add one; it only adds what is missing. The files are the project's own from then on: edit them with the team.

Each feature then gets `docs/features/F-xx-<name>/` with `spec.md`, `plan.md` and `review.md`, and a branch `feat/F-xx-<name>`. `--minimal` creates only `.pg/`, `docs/workflow.md` and the feature templates.

The skills run the project's **check command** from `CLAUDE.md` (for example `make check`) before every code commit. If the project has none, `/pg:init` proposes one.

## Commands

| Command | What it does |
|---|---|
| `/pg:init` | Sets up a repository: `.pg/`, workflow, backlog, ADR and feature templates, baseline standards, the check command in `CLAUDE.md`. `--minimal` for a time-boxed task. |
| `/pg:spec` | Interview, then a one-page spec with testable acceptance criteria. |
| `/pg:plan` | Research, then a plan of red/green steps, each naming its tests first. |
| `/pg:tdd` | One plan step or review finding: a `test(...)` commit that fails, then a `feat(...)` commit that passes. |
| `/pg:review` | Independent review by the `pg:reviewer` agent in a fresh context; findings verified and triaged by the human. |
| `/pg:ship` | Proves every acceptance criterion, updates docs, opens the pull request after your yes. Without a git remote it writes `SUBMISSION.md` instead. |
| `/pg:quick` | A small fix or chore in one pass, test-first when behaviour changes. |
| `/pg:adr` | A numbered architecture decision record. |
| `/pg:new-command` | Adds one or more `/pg:*` commands to this toolkit from a description of what each should do, then commits on a branch and opens a pull request to `main`. |
| `/pg:slack-triage` | Reads the Slack messages an instruction points at and writes a sectioned report in chat, one section per item: topic, quoted fragment, the concrete problem, first analysis and the action for you. Read-only. |
| `/pg:audit-branch` | Audits one branch against a base before merging: security, error handling and logs, compliance, architecture with build and tests run, and merge risks. Writes a report in chat with a merge-readiness percentage, risk per area and what to fix. Read-only. |

## Hooks

Both act only in a repository with a `.pg/` directory.

- **tdd-guard** (before edits): while `.pg/state/tdd-phase` says `green`, test files are read-only, so the code commit cannot quietly change the tests it must pass. `/pg:tdd` and `/pg:quick` set and clear the phase. Test paths: defaults for common stacks (`tests/`, `__tests__/`, `*.test.*`, `*.spec.*`, `*_test.go`, `test_*.py`, `*Test.java`, ...; full list in `plugins/pg/hooks/lib/test-paths.sh`), or `.pg/test-paths`, one glob per line, where `*` also matches `/`. If a session gets stuck in green, `rm .pg/state/tdd-phase` unlocks it.
- **format-on-edit** (after edits): runs the formatter of the project that owns the file: prettier, ruff, gofmt or rustfmt. A missing formatter is skipped.

## Agent

- **pg:reviewer**: read-only, started by `/pg:review` with only the git range, the spec, the plan and the standards, never the conversation that built the change. Checks correctness, security and AI (against the OWASP lists the standards map), privacy, design, performance, accessibility, tests and maintainability, against whichever standards the project has. Returns findings with severity, location, the rule broken and a fix.

## Routines

[`routines/`](routines/README.md) holds prompts for scheduled tasks in the Claude desktop app, separate from the plugin: a daily AI digest and a daily home country and world digest, each posted to a Slack channel through a webhook. The routines README covers the Slack setup, the env file and its variables, and keeping the Mac awake.

## Development

```bash
scripts/check.sh
```

Runs the hook tests, JSON and frontmatter checks, `shellcheck` and `claude plugin validate` when installed; CI runs the same. Hook changes are test-first, and nothing is copied from employer or client material; see [CLAUDE.md](CLAUDE.md). Changes are listed in [CHANGELOG.md](CHANGELOG.md).

## Licence

[MIT](LICENSE).

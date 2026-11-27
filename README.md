# pg-toolkit

[![CI](https://github.com/pg013c/pg-toolkit/actions/workflows/ci.yml/badge.svg)](https://github.com/pg013c/pg-toolkit/actions/workflows/ci.yml) [![Release](https://img.shields.io/github/v/release/pg013c/pg-toolkit)](https://github.com/pg013c/pg-toolkit/releases) [![License: MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

My Claude Code toolkit: the skills, agent and hooks I carry from project to project. It packages one way of working with a coding agent: the agent proposes and builds, the human approves at the spec, the plan, the review triage and the merge, and every behaviour change lands test-first, visible in git history.

## Requirements

- Claude Code with plugin support (`claude plugin --help` works).
- `git` and `jq` (the hooks read the tool call with `jq`; without it `tdd-guard` warns and does not protect tests).
- Optional: `gh` for `/pg:ship` and `/pg:new-command` to open pull requests; a connected Slack integration for `/pg:slack-triage`; a connected docs integration (and optionally Slack) for `/pg:project-docs`; the project's own formatters for `format-on-edit`.

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

Check it: `claude plugin details pg@pg-toolkit` lists 40 skills, 2 agents and 2 hooks.

Update an install from GitHub: `claude plugin marketplace update pg-toolkit`, then `claude plugin update pg@pg-toolkit`. Remove: `claude plugin uninstall pg@pg-toolkit`.

## Quick start

In the repository you work on, start Claude Code and run:

1. `/pg:init` once. It asks before creating anything and never overwrites files. Use `/pg:init --minimal` for a take-home or live-coding task.
2. A feature: `/pg:spec <what it should do>` → approve → `/pg:plan F-01` → approve → `/pg:tdd F-01` once per step → `/pg:review F-01` → decide each finding → `/pg:tdd F-01 <finding>` for each `fix` → `/pg:ship F-01`.
3. A small fix or chore: `/pg:quick <what to change>`. If it is not small, it says so and suggests `/pg:spec`.

The human approves at four points: the spec, the plan, the review triage and the merge. Skills commit their own work after each approval; pushing and opening a pull request always waits for an explicit yes, and nothing is ever merged by the agent.

## Example

[`examples/`](examples/README.md) follows one invented feature through the whole workflow: the spec, the plan, the review and the git history each stage leaves behind, including the moment the TDD guard stops the agent from loosening a test.

## What `/pg:init` adds to a project

```text
.pg/                       marker that turns the hooks on for this repository
.pg/state/                 TDD phase (gitignored)
.pg/test-paths             optional: your test globs, one per line, replacing the defaults
.pg/allow                  optional: git-guard rules lifted here (force-push, push-main, merge)
.pg/protected              optional: ports, paths and commands of your own running instance
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
| `/pg:research` | Read-only investigation of a question or a feature's area: what exists, what to reuse, what is risky, with file references. For a feature it writes `research.md`, which `/pg:plan` starts from. |
| `/pg:tdd` | One plan step or review finding: a `test(...)` commit that fails, then a `feat(...)` commit that passes. |
| `/pg:review` | Independent review by the `pg:reviewer` agent in a fresh context; findings verified and triaged by the human. |
| `/pg:ship` | Proves every acceptance criterion, updates docs, opens the pull request after your yes. Without a git remote it writes `SUBMISSION.md` instead. |
| `/pg:quick` | A small fix or chore in one pass, test-first when behaviour changes. |
| `/pg:adr` | A numbered architecture decision record. |
| `/pg:adr-recover` | Recovers the decisions an existing codebase already made from its code, configuration, dependencies and history, proposes them with evidence and certainty, and writes the ones you pick as ADRs marked as recorded after the fact. |
| `/pg:onboard` | First look at a project you take over: reads the code, docs and git history without running anything and reports in chat how it understands the project, how to run it, the state of the repository, what is missing before work can start (security red flags, data-destroying scripts, docs drift, dependency health, tests and CI), decisions, questions for the previous owners and a readiness percentage. Offers to draft `README.md` and `CLAUDE.md` only when they are missing. Read-only. |
| `/pg:new-command` | Adds one or more `/pg:*` commands to this toolkit from a description of what each should do, then commits on a branch and opens a pull request to `main`. |
| `/pg:slack-triage` | Reads the Slack messages an instruction points at and writes a sectioned report in chat, one section per item: topic, quoted fragment, the concrete problem, first analysis and the action for you. Read-only. |
| `/pg:audit-branch` | Audits one branch against a base before merging: security, error handling and logs, compliance, architecture with build and tests run, and merge risks. Writes a report in chat with a merge-readiness percentage, risk per area and what to fix. Read-only. |
| `/pg:audit` | Audits the whole repository in one area or all: security, ai, privacy, architecture, dead-code, performance, accessibility. Every finding verified, with an id, severity, location, rule, evidence, fix and size, ready to become a backlog item. Read-only; `--save` writes the report to `docs/audits/`. |
| `/pg:refactor` | Restructures code without changing behaviour, from one `/pg:audit` finding, a backlog entry or a named scope: characterization tests pin the current behaviour first, then small `refactor(...)` commits with the tests locked and the checks run after each. Stops when behaviour, a test or an ADR would change. |
| `/pg:pr-review` | Reviews one PR, a list of PRs or a branch: correctness, business logic, security, infrastructure, docs, tests and merge risks, with the project's checks run. Reports a 0-10 safety score in chat, drafts the review and posts it as approve (7 or more) or request changes only after your yes, then offers a note to the author, sent on Slack after a yes. `--follow-up` reviews a followed PR again; `--auto` runs unattended for a scheduler and `--auto --decide` also approves or requests changes behind hard gates. |
| `/pg:release-gate` | Unattended gate for CI: checks the changes against a base and writes a FAIL, WARN or PASS verdict as `gate.json` plus a markdown summary for a pull-request comment. Never asks, never posts. |
| `/pg:eval-run` | Runs the project's evaluation suite for model behaviour, compares each metric with its target and the last baseline, explains regressions through the `pg:eval-analyst` agent and records the run. |
| `/pg:report` | A report for a reader who does not read code, grounded in the code, docs and history, in plain language, with every claim tied to an entry in a separate evidence file a developer can check. |
| `/pg:deck` | A presentation in two approved steps: an outline slide by slide with speaker notes, then one self-contained HTML file that works offline, moves with the keyboard, shows notes and prints to PDF. |
| `/pg:workshop` | Designs a workshop or training: outcomes, pre-survey, timed agenda, hands-on exercises on participants' own tasks, facilitator guide, feedback survey with a recommendation score and a follow-up plan. |
| `/pg:mock-interview` | Practise a job interview with the assistant as a recruiter, manager, tech lead or CTO, one question at a time with real follow-ups, then a report with a readiness percentage and better answers built from your own facts. `--talk` rehearses a presentation and its Q&A. |
| `/pg:save-note` | Saves an idea, analysis or artifact from the conversation into your notes repository: right folder, dated name, frontmatter, self-contained, confidential details rewritten out; commits and pushes. |
| `/pg:project-docs` | Keeps a private archive of a client project's shared materials in a local git repository with no remote: `init` writes an index of sources, people, dates and repos; `snapshot` exports each shared document to markdown; `refresh` re-reads them since the stored revision, commits what changed and reports it per document, optionally with new Slack messages. Never pushes or sends. |
| `/pg:inbox-tidy` | Sorts the notes repository's inbox: proposes a folder, name and frontmatter per item, flags confidential items with whether they were already pushed, and applies only the approved plan. |
| `/pg:draft-reply` | Drafts a reply to a message or thread after reading it, in the right voice (first person and unsigned when you send it), and sends it only after you approve the exact text. |
| `/pg:inbox-loop` | Works through an inbox with you: one list of everything waiting, then one item at a time with a reminder, a recommendation and a draft; records each outcome in a tracker. Never sends anything itself. |
| `/pg:progress` | Writes a short progress note at the end of a session into `docs/progress/`: done, decided, open, next, each linked to commits and files. |
| `/pg:cleanup` | Lists stale local branches and worktrees with what would be lost, and deletes only what you approve, printing how to restore each branch. |
| `/pg:idea-note` | Turns a raw idea, often one sentence, into a structured half-page note (problem, how it works, value, risks, first step, tags), shows it in chat and saves it into your notes repository after your yes. |
| `/pg:ideate` | Talks an idea for an app, a game or a tool through before anything is built: a report in chat with how the assistant understands it, strengths, weaknesses, gaps, ways to build it, directions to grow and extra features, refined in later rounds. Writes nothing. |
| `/pg:brainstorm` | Generates as many ideas as possible around yours: features, variants, related products, directions to grow, markets, ways to earn and wild cards, from several subagents with different creative lenses, merged into numbered clusters in chat. Later rounds give more, expand or combine ideas. Writes nothing. |
| `/pg:problem-to-app` | Starts from a problem or an area of life and proposes three products that could solve it, each in a different form (mobile, web, AI assistant, bot and more), with users, MVP, how it earns, competitors and risk, plus a recommended pick. Later rounds give more, expand one or save it with `/pg:idea-note`. Writes nothing. |
| `/pg:build` | Builds a whole PRD (`--autopilot` answers the gates itself, recording every decision): splits it into features, then takes each one through spec, plan, tdd, review and ship, every stage in its own Sonnet subagent. You approve the split, each spec, each plan and each review triage; pushing waits for your yes. |
| `/pg:prd` | Turns an idea, and any notes, code or old documents about it, into a build-ready PRD/BRD for a coding agent through an iterative interview: checks six areas, points out bottlenecks, proposes options with a recommendation and ends every reply with a readiness percentage. On your command writes the document in one markdown block. Writes nothing without your yes. |
| `/pg:improve-prompt` | Rewrites a prompt as a prompt engineer so a model understands it without guessing: goal, context, structure, constraints, output format and definition of done. Returns the improved prompt in one copyable block with what changed and why, refined in later rounds. Writes nothing. |
| `/pg:discuss` | Talks a task through before doing it: how it understands the task, two or three approaches with pros and cons, a recommendation, risks and questions, grounded read-only in the repository. Continued round by round, ends with a summary of what was agreed. No code, files or artifacts. |
| `/pg:analyze-doc` | Analyses any document, file, page, message or pasted text against its purpose: the purpose with certainty and clarity scores, how far it achieves it as a percentage, what is valuable, inconsistencies, and suggestions to reach 100%, each in its own section of a report in chat. Read-only. |
| `/pg:deploy` | Deploys the project by a recipe in `docs/deploy.md`: `init` works it out from the project's files and writes it after your yes, `apply` runs preflight, shows the plan and after your yes builds, ships, migrates, clears caches and verifies, asking again before irreversible steps; `add-step` extends the recipe. |

## Hooks

All act only in a repository with a `.pg/` directory.

- **tdd-guard** (before edits): while `.pg/state/tdd-phase` says `green`, test files are read-only, so the code commit cannot quietly change the tests it must pass. `/pg:tdd` and `/pg:quick` set and clear the phase. Test paths: defaults for common stacks (`tests/`, `__tests__/`, `*.test.*`, `*.spec.*`, `*_test.go`, `test_*.py`, `*Test.java`, ...; full list in `plugins/pg/hooks/lib/test-paths.sh`), or `.pg/test-paths`, one glob per line, where `*` also matches `/`. If a session gets stuck in green, `rm .pg/state/tdd-phase` unlocks it.
- **git-guard** (before shell commands): refuses force pushes, pushes to the main branch (`main` or `master`, named or as the current branch) and `gh pr merge`, so the human stays the one who merges. A line in `.pg/allow` lifts a rule for that repository: `force-push`, `push-main`, `merge` (for example `push-main` in a solo repository that works on main).
- **protect-instance** (before shell commands): refuses commands that would stop or change the instance you work with, listed in `.pg/protected`, one per line: `port 4600` (killing whatever listens on it), `path ~/.app-data` (removing or moving it), `command pnpm app:*` (running a matching command). The agent then uses a throwaway data directory and a free port instead.
- **format-on-edit** (after edits): runs the formatter of the project that owns the file: prettier, ruff, gofmt or rustfmt. A missing formatter is skipped.

## Agents

- **pg:reviewer**: read-only, started by `/pg:review` with only the git range, the spec, the plan and the standards, never the conversation that built the change. Checks correctness, security and AI (against the OWASP lists the standards map), privacy, design, performance, accessibility, tests and maintainability, against whichever standards the project has. Returns findings with severity, location, the rule broken and a fix.
- **pg:eval-analyst**: read-only, started by `/pg:eval-run` when a metric misses its target or regresses. Groups the failing cases, follows a few end to end and says where each group fails: retrieval, ranking or context, the model, output handling, or the case itself.

## Development

```bash
scripts/check.sh
```

Runs the hook tests, JSON and frontmatter checks, `shellcheck` and `claude plugin validate` when installed; CI runs the same. Hook changes are test-first, and nothing is copied from employer or client material; see [CLAUDE.md](CLAUDE.md). Changes are listed in [CHANGELOG.md](CHANGELOG.md); how to contribute and release is in [CONTRIBUTING.md](CONTRIBUTING.md).

## Licence

[MIT](LICENSE).

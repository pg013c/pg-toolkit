# pg-toolkit

My Claude Code toolkit: the skills, agent and hooks I carry from project to project. It packages one way of working with a coding agent: the agent proposes and builds, the human approves at the spec, the plan, the review triage and the merge, and every behaviour change lands test-first, visible in git history.

## Install

From GitHub:

```bash
claude plugin marketplace add pg013c/pg-toolkit
claude plugin install pg@pg-toolkit
```

From a local clone (changes apply after `claude plugin marketplace update pg-toolkit`):

```bash
claude plugin marketplace add ~/pvsw/pg-toolkit
claude plugin install pg@pg-toolkit
```

Then, once per repository: `/pg:init`.

## Commands

| Command | What it does |
|---|---|
| `/pg:init` | Sets up a repository: `.pg/`, workflow, backlog, ADR and feature templates, baseline standards, the check command in `CLAUDE.md`. `--minimal` for a time-boxed task. |
| `/pg:spec` | Interview, then a one-page spec with testable acceptance criteria. |
| `/pg:plan` | Research, then a plan of red/green steps, each naming its tests first. |
| `/pg:tdd` | One plan step or review finding: a `test(...)` commit that fails, then a `feat(...)` commit that passes. |
| `/pg:review` | Independent review by the `pg:reviewer` agent in a fresh context; findings verified and triaged by the human. |
| `/pg:ship` | Proves every acceptance criterion, updates docs, opens the pull request. |
| `/pg:quick` | A small fix or chore in one pass, test-first when behaviour changes. |
| `/pg:adr` | A numbered architecture decision record. |

## Hooks

Both act only in a repository with a `.pg/` directory.

- **tdd-guard** (before edits): while `.pg/state/tdd-phase` says `green`, test files are read-only, so the code commit cannot quietly change the tests it must pass. Test paths: sensible defaults for common stacks, or `.pg/test-paths`, one glob per line.
- **format-on-edit** (after edits): runs the formatter of the project that owns the file: prettier, ruff, gofmt or rustfmt. A missing formatter is skipped.

## Development

```bash
scripts/check.sh
```

Hook changes are test-first; see [CLAUDE.md](CLAUDE.md).

## Licence

[MIT](LICENSE).

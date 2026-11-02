# pg-toolkit

A Claude Code marketplace with one plugin, `pg`: skills, an agent and hooks for a spec-first, test-first workflow. Public, MIT.

## Layout

- `.claude-plugin/marketplace.json`: the marketplace (`pg-toolkit`).
- `plugins/pg/`: the plugin. `skills/<name>/SKILL.md` is invoked as `/pg:<name>`; `agents/`, `hooks/` (`hooks.json` plus scripts), `templates/` (files `/pg:init` copies into a project).
- `routines/`: prompts for scheduled tasks in the Claude desktop app, not part of the plugin. Secrets live in a local env file, never in the prompts.
- `tests/`: shell tests for the hooks. `scripts/check.sh` runs every check CI runs.

## Rules

- Everything is written from scratch. Never copy text or code from an employer's or client's toolkit, repository or document, and never name a client, employer, person or internal system. Ideas are fine; their wording is ours.
- English, plain and short. No private data: no emails, tokens, client names or paths from other projects.
- Skills must work in any repository. They read project facts (check command, test paths) from the project, never assume a stack.
- Hooks do nothing in a project without a `.pg/` directory, and never block on their own errors: a missing tool is a warning, not a refusal.
- Hook changes are test-first: a `test(hooks): ...` commit with failing tests, then a `feat(hooks): ...` or `fix(hooks): ...` commit that does not touch `tests/`.
- Commit messages: Conventional Commits, scope `hooks`, `skills`, `agents`, `templates`, `routines`, `ci` or `docs`. Bump `plugins/pg/.claude-plugin/plugin.json` `version` and add a `CHANGELOG.md` entry for every change a user would notice.

## Checks

```bash
scripts/check.sh
```

Runs the hook tests, JSON validation, skill frontmatter checks and, when installed, `shellcheck` and `claude plugin validate`.

# pg-toolkit

A Claude Code marketplace with one plugin, `pg`: skills, an agent and hooks for a spec-first, test-first workflow. Public, MIT.

## Layout

- `.claude-plugin/marketplace.json`: the marketplace (`pg-toolkit`).
- `plugins/pg/`: the plugin. `skills/<name>/SKILL.md` is invoked as `/pg:<name>`; `agents/`, `hooks/` (`hooks.json` plus scripts), `templates/` (files `/pg:init` copies into a project).
- `routines/`: prompts for scheduled tasks in the Claude desktop app, not part of the plugin. Secrets live in a local env file, never in the prompts.
- `tests/`: shell tests for the hooks. `scripts/check.sh` runs every check CI runs.

## Rules

- Everything is written from scratch. Never copy text or code from an employer's or client's toolkit, repository or document. Ideas are fine; their wording is ours.
- The toolkit is universal and public: it knows nothing about the work it is used for. No names of projects, clients, companies, products, domains, tasks, tickets or people (the author's name in `LICENSE` and the plugin metadata is the only exception), and no mention of the author's other tools, apps, servers or local paths. Skills talk about "the user's task tool", never a specific one. Examples are generic and invented (`<person>`, "the public site", "#ops"), never taken from a real conversation or project.
- Before every commit, check the diff for such details. `scripts/check.sh` also scans the repository for the terms listed in a local, untracked file (see Checks).
- English, plain and short. No private data: no emails, tokens or paths from other projects.
- Skills must work in any repository. They read project facts (check command, test paths) from the project, never assume a stack.
- Hooks do nothing in a project without a `.pg/` directory, and never block on their own errors: a missing tool is a warning, not a refusal.
- Hook changes are test-first: a `test(hooks): ...` commit with failing tests, then a `feat(hooks): ...` or `fix(hooks): ...` commit that does not touch `tests/`.
- Commit messages: Conventional Commits, scope `hooks`, `skills`, `agents`, `templates`, `routines`, `ci` or `docs`. Bump `plugins/pg/.claude-plugin/plugin.json` `version` and add a `CHANGELOG.md` entry for every change a user would notice.

## Checks

```bash
scripts/check.sh
```

Runs the hook tests, JSON validation, skill frontmatter checks, the private-terms scan and, when installed, `shellcheck` and `claude plugin validate`.

The private-terms scan reads `~/.config/pg-toolkit/private-terms` (or the file in `$PG_PRIVATE_TERMS`): one case-insensitive extended regex per line, `#` for comments. It lives outside the repository so the terms themselves are never published; without the file the scan is skipped.

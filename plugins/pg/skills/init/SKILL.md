---
name: init
description: Set up the pg workflow in the current repository - .pg/ marker, docs (workflow, backlog, ADRs, standards, feature templates) and a "pg workflow" section in CLAUDE.md with the project's check command. Use once per repository, before /pg:spec or /pg:quick, including a fresh take-home or live-coding repo.
argument-hint: "[--minimal]"
---

# /pg:init

Prepares a repository for the other `pg` skills. Templates are in this plugin's `templates/` folder, two levels up from this skill's directory.

## Steps

1. Confirm this is the root of a git repository (`git rev-parse --show-toplevel`). If not, offer `git init` and wait for an answer.
2. Detect the stack from manifest files (`package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `composer.json`, `pom.xml`, `build.gradle*`, `*.csproj`, `Makefile`) and the CI config. Find the commands that already exist for format, lint, type check and test.
3. Work out the **check command**: the one command that runs everything CI runs (for example `make check`, `pnpm check`, `uv run poe check`). If there is none, propose adding one to the existing task runner and show the exact change. Do not add it without the human's yes.
4. List what you will create, then wait for a go-ahead. Skip any file that already exists and say so; never overwrite.
   - `.pg/` with `state/` (add `.pg/state/` to `.gitignore`),
   - `docs/workflow.md`, `docs/backlog.md`, `docs/adr/README.md`, `docs/adr/template.md`,
   - `docs/features/_templates/{spec,plan,review}.md`,
   - `docs/standards/{general,testing,security}.md`,
   - `docs/standards/<stack>.md`: a short draft of stack rules, written by you from what the project already does (linters, formatter, folder layout, test framework), each rule with an id. Mark it `Status: draft`.
   With `--minimal` (a time-boxed task), create only `.pg/`, `docs/workflow.md` and the feature templates.
5. Check the test path defaults against the project (the globs are in `hooks/lib/test-paths.sh` in this plugin). If the project keeps tests elsewhere, write `.pg/test-paths` with one glob per line.
6. Add this section to `CLAUDE.md` (create the file if needed), filled in:

   ```markdown
   ## pg workflow

   - Check: `<check command>`
   - Tests only: `<test command>`
   - Main branch: `<main>`
   - Process: docs/workflow.md. Standards: docs/standards/. Decisions: docs/adr/. Backlog: docs/backlog.md.
   ```

7. Run the check command once and report whether it passes today. A failing baseline is reported, not fixed here.
8. Show the summary and the files. Commit only on the human's yes: `chore: set up pg workflow`.

## Rules

- Never overwrite existing files or change existing tooling without an explicit yes.
- Write the docs in the language the repository already uses; English if unsure.

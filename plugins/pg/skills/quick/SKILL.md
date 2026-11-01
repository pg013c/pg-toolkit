---
name: quick
description: Make one small change (a bug fix, a chore, a tweak to existing behaviour) in a single pass without a spec or plan - reproduce, red/green when behaviour changes, run checks, commit. Hands the task back with a recommendation when it turns out bigger. Use for work under about an hour that touches few files.
argument-hint: "<what to change>"
---

# /pg:quick <what to change>

## Is it quick?

Before touching anything, read the code involved and decide. It is quick when it fits in one or two red/green pairs, touches a few files, needs no new dependency or decision worth an ADR, and its expected behaviour is clear. If not, stop and recommend `/pg:spec` with a one-line reason.

## Steps

1. Branch from an up-to-date main: `fix/<short-name>` or `chore/<short-name>`. Working tree must be clean.
2. If behaviour changes, work test-first with the same phase file as `/pg:tdd`:
   - `mkdir -p .pg/state && echo red > .pg/state/tdd-phase`, write a test that reproduces the bug or specifies the change, show it failing, commit `test(<scope>): ...`;
   - `echo green > .pg/state/tdd-phase`, make it pass without editing tests, run the check command, commit `fix(<scope>): ...` or `feat(<scope>): ...`;
   - `rm -f .pg/state/tdd-phase`.
3. A change with no behaviour (dependency bump, config, rename, docs) is one commit after the check command passes: `chore(...)`, `refactor(...)` or `docs(...)`.
4. Report the commits and what was verified. Suggest `/pg:review` before merging when the change touches security, data or a public interface.

## Rules

- Do not widen the scope. Anything else you notice goes into the report as a suggestion.
- If you find the expected behaviour unclear, ask one question with your recommended answer instead of guessing.

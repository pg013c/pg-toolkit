---
name: tdd
description: Implement the next unchecked step of an approved plan, or one review finding marked fix, as a red commit with failing tests and a green commit with the code that passes them; test files are locked during green. Use for all implementation work on a feature or fix branch.
argument-hint: "F-xx [step | finding]"
---

# /pg:tdd F-xx [step | finding]

Delivers one plan step, or one review finding marked `fix`, as a red/green commit pair. The phase lives in `.pg/state/tdd-phase` (not committed); while it says `green`, the plugin's `tdd-guard` hook refuses edits to test files.

## Red

1. Read `plan.md` and pick the step (default: the first without `red` ticked). For a finding, read its row in `review.md`.
2. Confirm you are on the feature branch and the working tree is clean.
3. Run `mkdir -p .pg/state && echo red > .pg/state/tdd-phase`.
4. Write the tests the step names. Follow `docs/standards/testing.md`.
5. Add only the stubs the tests need to load: signatures that throw "not implemented". No logic.
6. Run the new tests. They must fail, and for the reason the step addresses (an assertion or "not implemented"), not because the test itself is broken. Show the failure.
7. Run format, lint and type checks (not the test suite), so the commit is clean.
8. Commit `test(<scope>): <behaviour specified>` with `Refs: F-xx`. Tick `red` in the plan in the same commit.

## Green

1. Run `echo green > .pg/state/tdd-phase`.
2. Write the smallest change that makes the tests pass, following `docs/standards/`. Do not edit tests. If a test is wrong, stop, explain why, and with the human's agreement go back to Red with a separate `test(...)` commit that says what changed.
3. Run the check command from CLAUDE.md. Everything must pass, not only the new tests.
4. Commit `feat(<scope>): ...` (or `fix(<scope>): ...` for a finding or bug) with `Refs: F-xx`. Tick `green` in the plan in the same commit.
5. Optional: a `refactor(<scope>): ...` commit, tests untouched and green.
6. Run `rm -f .pg/state/tdd-phase`.

## Then

- Report: the step, both commit hashes, anything surprising.
- After the last step, suggest `/pg:review F-xx`.
- One step per invocation unless the human asks for more.

# Workflow

How changes are made in this repository, with a coding agent and a human. The agent proposes and builds; the human approves at four points: the spec, the plan, the review triage and the merge.

## 1. A feature, step by step

| Step | Command | Output | Human |
|---|---|---|---|
| Spec | `/pg:spec F-xx` | `docs/features/F-xx-*/spec.md` | approves |
| Plan | `/pg:plan F-xx` | `docs/features/F-xx-*/plan.md` | approves |
| Build | `/pg:tdd F-xx` per step | a `test(...)` commit, then a `feat(...)` commit | |
| Review | `/pg:review F-xx` | `docs/features/F-xx-*/review.md` | decides each finding |
| Fix | `/pg:tdd F-xx <finding>` | red/green pair per finding | |
| Ship | `/pg:ship F-xx` | pull request | merges |

Small fixes and chores skip the spec and plan: `/pg:quick <what>`.

## 2. Test first, visible in history

Every behaviour change is two commits: `test(scope): ...` with failing tests, then `feat(scope): ...` or `fix(scope): ...` with the code that makes them pass. The code commit does not touch tests; the `tdd-guard` hook enforces it while `.pg/state/tdd-phase` says `green`. A wrong test is fixed in its own `test(...)` commit that says why.

Which paths are tests: the defaults in the `pg` plugin, or `.pg/test-paths` when present (one glob per line).

## 3. Commits

Conventional Commits. Feature work carries `Refs: F-xx`. One logical change per commit; every commit passes the check command.

## 4. Decisions

A decision that is hard to reverse, adds a dependency or a service, or changes a standard gets an ADR (`/pg:adr`) before the code that depends on it.

## 5. Definition of done

- Every acceptance criterion has a passing test that proves it, named next to the criterion.
- The check command passes.
- Every review finding has a decision, and every `fix` has its commits.
- Docs touched by the change are updated: README, architecture, ADR index, backlog.

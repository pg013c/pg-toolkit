---
name: plan
description: Research the codebase and write the step-by-step implementation plan for an approved spec (docs/features/F-xx-*/plan.md); every step names its tests first and every acceptance criterion maps to a step. Use after /pg:spec is approved, before /pg:tdd.
argument-hint: F-xx
---

# /pg:plan F-xx

Produces `plan.md` next to the approved `spec.md`, from `docs/features/_templates/plan.md`.

## Steps

1. Read `spec.md`. If it is not `approved`, stop and say so.
2. Research before designing. Read the code the feature touches: entry points, modules, interfaces, existing tests, fakes and fixtures. When more than a handful of files are involved, use a read-only subagent (Explore) and keep only its conclusions. Write the Research section: what exists, what to reuse, what is risky.
3. Design briefly against `docs/standards/` and the ADRs. A decision that needs an ADR is written with `/pg:adr` before the plan is approved.
4. Split the work into steps that one red and one green commit can cover (roughly 15 to 60 minutes each). Order them so every green commit leaves the branch fit to merge:
   - interfaces and fakes before real adapters,
   - domain logic before transport (routes, CLI, handlers),
   - transport before UI.
5. For each step write: kind, the tests to write first and what they assert, the files to change, and when it is done. A `setup` step (tooling, scaffolding) is one commit without red/green.
6. Map every acceptance criterion to at least one step. A criterion without a step means the plan is not finished.
7. Set the backlog status to `building`. Show the plan and wait for approval.
8. On approval set `Status: approved` and commit `docs(F-xx): add plan` with `Refs: F-xx`.

## Rules

- No code beyond signatures that clarify an interface or a schema.
- Apply the standards; do not restate them.
- If the spec turns out wrong or incomplete, stop and propose a spec change instead of planning around it.

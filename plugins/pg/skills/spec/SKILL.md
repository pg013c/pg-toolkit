---
name: spec
description: Write the specification of one feature (docs/features/F-xx-*/spec.md) through a short interview - intent, scope, out of scope and testable acceptance criteria, no design. Use at the start of every feature, before /pg:plan or any code.
argument-hint: "<F-xx | what the feature should do>"
---

# /pg:spec

Produces `docs/features/F-xx-<short-name>/spec.md` from `docs/features/_templates/spec.md`. The spec says what and why. How belongs to `/pg:plan`.

## Steps

1. If `.pg/` is missing, say so and suggest `/pg:init`.
2. Find the feature. With an id, read its row in `docs/backlog.md`. With a description, take the next free `F-xx` and add a backlog row (status `todo`). Read related ADRs, the specs of features it depends on, and the code it will touch, enough to ask good questions.
3. Create the branch `feat/F-xx-<short-name>` from an up-to-date main branch, unless it exists.
4. Draft the spec first. Then ask only what the documents and code cannot answer: one batch, at most five questions, each with your recommended answer. Typical gaps: edge cases, error behaviour, limits, what is out of scope, what "done" looks like.
5. Write acceptance criteria as Given / When / Then. Each must be observable from outside and provable by a test. Include the error and edge cases the answers revealed.
6. Put decisions that need an ADR under open questions, with a suggestion to run `/pg:adr`.
7. Set the backlog status to `spec`. Show the spec and wait for approval.
8. On approval set `Status: approved` and commit `docs(F-xx): add spec` with `Refs: F-xx`.

## Rules

- One page at most. A longer spec means the feature should be split: propose the split in the backlog.
- No design, no file names, no implementation steps.
- Do not start planning or coding here.

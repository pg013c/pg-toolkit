---
name: adr
description: Record an architecture decision as a numbered ADR in docs/adr/ with context, real alternatives and consequences. Use when a decision is hard to reverse, adds a dependency, service or protocol, or changes a standard.
argument-hint: "<decision in a few words>"
---

# /pg:adr <decision>

Writes `docs/adr/NNNN-<kebab-title>.md` from `docs/adr/template.md`.

## Steps

1. Read `docs/adr/README.md` for the next number and the existing records. If one already covers the topic, the new record supersedes it; mark that in the old record's status line only.
2. Gather the context from the conversation, the specs and the code. Keep facts (context) apart from the choice (decision).
3. Name at least two real alternatives and why each lost. If there is no real alternative, this probably needs no ADR: say so and stop.
4. Write the consequences, including follow-ups: standards to change, backlog items, configuration.
5. For a new dependency or service, state its licence, maintenance status and what it costs to run.
6. Add the record to the index. Show it with `Status: proposed`.
7. On acceptance set `accepted`, apply any standards change it requires, and commit `docs(adr): <title>`.

## Rules

- One decision per record, under one page.
- Accepted records are never rewritten; a change of mind is a new record.

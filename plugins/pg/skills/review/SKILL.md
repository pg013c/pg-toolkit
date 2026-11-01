---
name: review
description: Review everything the current branch changes against its spec, plan and the project's standards, through the pg reviewer agent with a fresh context; verify each finding and write them to review.md for the human to triage. Use when a feature's steps are done, and for every fix or chore branch.
argument-hint: "[F-xx]"
---

# /pg:review [F-xx]

## Steps

1. Range: `<main>...HEAD`, with the main branch from CLAUDE.md. If the working tree has uncommitted changes, stop and ask to commit or stash them.
2. Run the check command. A failing check is reported as a blocker, without a full review.
3. Start the `pg:reviewer` agent. Give it only the range and paths: `spec.md`, `plan.md`, `docs/standards/`, the relevant ADRs. Do not give it your opinion of the change or how it was built; its value is that it has seen neither.
4. Verify every finding it returns: open the cited lines and confirm the problem is real. Drop what you cannot confirm and record how many you dropped.
5. Write `docs/features/F-xx-*/review.md` from the template, ordered by severity, each finding citing a standard id or acceptance criterion where one applies. Leave Decision empty. For a branch without a feature folder, present the findings in the conversation instead.
6. Set the backlog status to `review`. Commit `docs(F-xx): add review` with `Refs: F-xx`.
7. Ask the human to decide each finding: `fix`, `backlog` or `reject: <reason>`. Record the decisions.
8. Each `fix` goes through `/pg:tdd F-xx <finding>`, one per invocation. When all are resolved, suggest `/pg:ship F-xx`.

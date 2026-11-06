---
name: build
description: Build what a PRD or requirements document describes, in one command - split it into features, then take each feature through the whole pg workflow (spec, plan, tdd step by step, review, ship) with every stage run by its own subagent on the Sonnet model, while the conversation coordinates and the human approves the split, each spec, each plan and each review triage. Use when you have a PRD for a repository that uses the pg workflow and want it built end to end. Not for compiling a project or fixing a broken build.
argument-hint: "<path to a PRD or requirements document, or the pasted text>"
---

# /pg:build <PRD>

Runs the pg workflow for a whole PRD. The conversation is the coordinator: it starts subagents, keeps only their summaries, and brings every question and approval to the human. Each stage is done by the stage's own skill, read from this skill's sibling folders (`../spec/SKILL.md`, `../plan/SKILL.md`, `../tdd/SKILL.md`, `../ship/SKILL.md`).

The human approves at four gates: the feature split, each spec, each plan and each review triage. Pushing and opening a pull request waits for an explicit yes per feature. Nothing is merged.

## Subagents

- Start every stage subagent with the Sonnet model (the Agent tool's `model` option). If the harness offers no model choice, use the default and say so once.
- One subagent at a time. Features run one after another: the TDD phase lives in one file per working tree, and later features often build on earlier ones.
- Each subagent gets only what its stage needs: the feature id, the path to the stage's skill, the PRD path and the sections that matter, the base branch, and the human's answers so far. Never the conversation that came before.
- Tell each subagent: "Read `<path>/SKILL.md` and follow it for F-xx. You cannot talk to the user. Where the skill asks a question or waits for approval, stop and return what you would show: the draft, the questions with your recommended answers, or the reason you stopped."
- A subagent cannot start another subagent, so the review stage, which needs the `pg:reviewer` agent, is run by the coordinator. The reviewer keeps its own model.
- When the human answers, continue the same subagent if the harness allows it; otherwise start a new one with the draft's path and the answers.

## Steps

1. Check the repository: `.pg/` exists (if not, say so and suggest `/pg:init`, then stop), `CLAUDE.md` has the pg workflow section with the check command and main branch, and the working tree is clean.
2. Read the PRD. A pasted PRD is saved to `docs/prd.md` and committed as `docs: add PRD` on the main branch after the human agrees; a path is used as it is.
3. Split. A subagent reads the PRD, `docs/backlog.md`, the README and the code the PRD touches, and proposes features. Each has the next free `F-xx` id, a short name, its goal in one or two sentences, the PRD sections it covers, and the features it depends on. Each must fit a one-page spec; a feature that would not is split further. List PRD requirements no feature covers, and what is left out on purpose.
4. **Gate 1.** Show the split as a table, in build order (dependencies first). Wait for approval. Take changes and show it again until it is approved.
5. For each feature, in build order:
   1. **Spec.** A subagent follows `/pg:spec` with the id, the feature's goal and its PRD sections, and adds the feature's backlog row under that id if it is missing. Base branch: the main branch, or the branch of the feature it depends on (the last one when there are several). It returns the draft and its questions.
   2. **Gate 2.** Show the spec and the questions. Pass the answers back; the subagent finishes the spec, sets it approved and commits.
   3. **Plan.** A subagent follows `/pg:plan`, including any ADR the plan needs, and returns the plan.
   4. **Gate 3.** Show the plan with its research and any ADR. Pass the human's changes back; on approval the subagent commits.
   5. **TDD.** For each unchecked step of the plan, a new subagent follows `/pg:tdd F-xx <step>` and returns the step, both commit hashes and anything surprising. Report each step in one line. If a subagent stops (a test looks wrong, the plan or spec does not fit, the check fails), bring it to the human and continue only with their decision.
   6. **Review.** Run `/pg:review F-xx` here in the conversation, with the feature branch's base as the range start: the reviewer agent, verification of every finding, `review.md`.
   7. **Gate 4.** Ask the human to decide each finding: `fix`, `backlog` or `reject: <reason>`. Each `fix` goes to a new subagent with `/pg:tdd F-xx <finding>`.
   8. **Ship.** A subagent follows `/pg:ship` up to the push: check command, every criterion proven, review resolved, docs updated and committed. Then ask the human before pushing. On yes, push and open the pull request against the feature's base branch, and note in it which pull request it builds on.
6. Report: a table of features with branch, pull request, status and what went to the backlog, plus the PRD requirements no feature covered.

## Rules

- Never skip a gate, even when the human says to keep going: a go-ahead covers the gate it answers.
- The stage skills are the source of truth. When this skill and a stage skill differ, follow the stage skill, except that subagents return to the coordinator instead of waiting.
- Keep the conversation small: summaries and paths, not file contents or tool output.
- Never merge, rebase or force-push. Changes to a base branch after a dependent branch was cut are the human's call.
- Running it again with the same PRD resumes: features with backlog status `done` are skipped, the rest continue from their status and the plan's ticks.

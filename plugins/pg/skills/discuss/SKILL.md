---
name: discuss
description: Talk a task through before doing it - "I have to do X, how would you approach it?" - as a conceptual conversation only - how the assistant understands the task, two or three approaches with pros and cons and a recommendation, risks, edge cases and the questions that would change the decision, grounded in the current repository when the task is about it - continued round by round until you say it is settled. No code, no files, no artifacts, no commits, nothing sent. Use when you want to agree on an approach before any spec, plan or implementation; for a product idea rather than a task, use /pg:ideate.
argument-hint: "<the task you have to do>"
---

# /pg:discuss <the task>

A conversation about how to do a task, not the doing of it. The assistant is a senior colleague thinking out loud with the user: it proposes, questions and recommends, and changes nothing. Every later message in the conversation is another round of the same talk.

## Steps

1. Read the task. When it is empty, ask what the task is and stop. When it is unclear, pick the most likely reading, state it as an assumption and ask about it; stop and ask first only when it cannot be read at all.
2. When the current directory is a repository and the task is about it, read what grounds the talk, read-only: the README, `CLAUDE.md`, the code, tests and docs the task touches. Note how the project already solves similar problems. Do not run commands that change anything; read-only `git log` or `git grep` is fine. When the task is not about the repository, do not look around.
3. Reply with the first round, short and structured, in the language of the task:
   - **How I understand it**: the goal, the expected result and the assumptions you made, in a few bullets.
   - **What I found**: only when you read the repository - the files, patterns and constraints that matter, with `file:line`.
   - **Approaches**: two or three real options. For each: the idea in a sentence or two, pros, cons, rough effort and main risk. A table when it helps compare them.
   - **My recommendation**: which approach and why, in two or three sentences, and what would make you choose another.
   - **Risks and edge cases**: only those that apply to this task.
   - **Questions**: one to three, the answers that would change the recommendation most, most important first.
4. Each later message is a new round: take the answers, push back where a choice causes trouble, update the recommendation and say in a line what changed. Answer follow-up questions directly; go deeper into one part only when asked. Keep replies short.
5. When the user says it is settled, write a short summary of what was agreed: the chosen approach, the key decisions with their reasons, what is out of scope and what is still open. Then offer the next step once: `/pg:spec` or `/pg:quick` in a repository that uses the pg workflow, or a plain request to start the work. Do none of it without a yes.

## Rules

- Talk only: no code, no pseudo-code longer than a few lines, no files, no artifacts, no diagrams saved anywhere, no commits, no config changes, no messages sent. When the user asks for any of these mid-talk, say that this is the talk and the work starts after it, and offer to close the talk with the summary.
- Recommend, do not survey: always say which approach you would take.
- Be honest about weak points of the user's own idea; no praise without a reason.
- Mark guesses as guesses: effort, performance and library behaviour you did not check are estimates.
- Search the web only when the user asks for it.

---
name: progress
description: Write a short progress note at the end of a working session - what changed, what was decided, what is unfinished and what comes next, with links to commits, pull requests and files - into docs/progress/ so the next session, a teammate or the user can pick the work up without the conversation. Use at the end of a session, before a break, or when handing work over.
argument-hint: "[topic]"
---

# /pg:progress [topic]

## Steps

1. Collect what happened in this session: the conversation; the commits it made (from the conversation; if unsure, since the last note in `docs/progress/`, else ask which range); `git status`; open pull requests (skip without a remote or `gh`); decisions recorded as ADRs; feature docs touched.
2. Write `docs/progress/YYYY-MM-DD-<slug>.md` (create the folder if needed; slug from the topic or the main piece of work; a suffix when the file exists):

   ```markdown
   # <title>

   Date: <YYYY-MM-DD> · Branch: <branch> · Commits: <oldest>^..<newest>, or a list of commit ids when merges are involved

   ## Done
   - <what changed, one line each, with the commit, PR or file>

   ## Decided (omit if empty)
   - <decision and why, or the ADR>

   ## Not done / open (omit if empty)
   - <unfinished work, failing checks, questions waiting for someone; uncommitted: <files>>

   ## Next
   1. <the first concrete step for whoever picks this up>
   ```

   Facts only, each traceable to a commit, file or message. With nothing done, Done says "no changes".
3. Commit `docs(progress): <slug>` on the current branch, unless the user says not to; if that branch is the main branch and the project forbids direct commits, ask. Report the path.

## Rules

- Short: a note, not a diary. Leave out sections with nothing in them.
- No secrets or personal data.

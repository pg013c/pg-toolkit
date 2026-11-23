---
name: progress
description: Write a short progress note at the end of a working session - what changed, what was decided, what is unfinished and what comes next, with links to commits, pull requests and files - into docs/progress/ so the next session, a teammate or the user can pick the work up without the conversation. Use at the end of a session, before a break, or when handing work over.
argument-hint: "[topic]"
---

# /pg:progress [topic]

## Steps

1. Collect what happened in this session: the conversation, `git log` since the session started (or since the last progress note), `git status`, open pull requests, decisions recorded as ADRs, feature docs touched.
2. Write `docs/progress/YYYY-MM-DD-<slug>.md` (slug from the topic or the main piece of work; a suffix when the file exists):

   ```markdown
   # <title>

   Date: <YYYY-MM-DD> · Branch: <branch> · Commits: <first>..<last>

   ## Done
   - <what changed, one line each, with the commit, PR or file>

   ## Decided
   - <decision and why, or the ADR>

   ## Not done / open
   - <unfinished work, failing checks, questions waiting for someone>

   ## Next
   1. <the first concrete step for whoever picks this up>
   ```

   Facts only, each traceable to a commit, file or message; uncommitted work is listed as such.
3. Commit `docs(progress): <slug>` on the current branch, unless the user says not to. Report the path.

## Rules

- Short: a note, not a diary. Leave out sections with nothing in them.
- No secrets or personal data.

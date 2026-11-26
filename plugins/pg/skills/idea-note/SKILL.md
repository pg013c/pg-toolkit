---
name: idea-note
description: Turn a short idea - often a single sentence - into a structured note of about half a page - the idea in one sentence, the problem and who has it, how it would work, what makes it valuable, risks and open questions, a first step and tags - shown in chat first, then saved into the user's notes repository (ideas folder, dated name, frontmatter, commit and push) after a yes. Use when the user throws in a raw idea and wants it written up as a proper note to keep, not just saved as it is; to save something already worked out in the conversation, use /pg:save-note.
argument-hint: "<the idea, one sentence or more> [--repo <path>]"
---

# /pg:idea-note <the idea> [--repo <path>]

Expands a raw idea into a short, self-contained note worth keeping. The assistant does the writing; the user only checks it before it is saved.

## Steps

1. Read the idea. Ask no questions first: pick the most likely reading and mark your assumptions in the note. Stop and ask only when the idea is too short to read at all (for example a single word).
2. When the idea comes from the current conversation (for example "#2" from an earlier list), take its content from there. Do not look around the current directory unless the idea is about it.
3. Write the note in the language of the idea, about half a page (roughly 250 to 400 words), with these sections:
   - **In one sentence**: what the idea is;
   - **Problem**: what hurts, for whom, and how people cope today;
   - **How it works**: the core of the solution in a few sentences, with one example of use;
   - **Why it is worth it**: what makes it valuable or different, and any way it could earn money;
   - **Risks and open questions**: what could make it fail and what is not known yet;
   - **First step**: the smallest thing to do to learn whether it holds;
   - **Tags**: three to six lowercase words.
   Mark guesses as guesses: markets and competitors are not checked unless the user asks for a web search.
4. Show the note in chat with the file name it would get and ask whether to save it, change it or leave it. Take corrections and show the changed note again.
5. On a yes, save it:
   - find the notes repository: `--repo`, else a path the user's global `CLAUDE.md` (then the project's) gives for a notes repository, else ask once; it must be a git repository, and the rules in its `README.md` and `CLAUDE.md` (folders, naming, frontmatter, what may not be saved) win over the defaults here;
   - remove anything that may not leave its context: secrets, personal data, and names or details of clients, employers or colleagues; rewrite them as generic wording, and ask if the point cannot survive without them;
   - write it to `ideas/YYYY-MM-DD-<slug>.md` (slug: two to five lowercase words) with frontmatter: exactly the repository's fields when it lists them, otherwise `title`, `date`, `type: idea`, `tags`, `source`;
   - commit `ideas: add <slug>`; before pushing, check `git log @{u}..HEAD`, and if commits other than the note's are unpushed, list them and ask; then push unless the repository's rules say otherwise.
6. Report the path and the commit. Offer `/pg:ideate` to think the idea through further or `/pg:brainstorm` to widen it; run neither without a yes.

## Rules

- One idea per note. For several ideas in one argument, write one note each and show them together.
- Never overwrite an existing file; add a suffix to the slug instead.
- Nothing is written, committed or pushed before the user's yes in step 4.
- If the push fails, keep the local commit and report the error; do not force anything.

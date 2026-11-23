---
name: save-note
description: Save something worth keeping from the current conversation - an idea, an analysis, research, a decision, an artifact - into the user's notes repository as a self-contained markdown file in the right folder, with a dated name and frontmatter, rewritten so it holds no confidential details, then commit and push it. Use when the user says "save this", "note this", "put this in my notes" or similar.
argument-hint: "[what to save] [--repo <path>] [--folder <name>]"
---

# /pg:save-note [what to save] [--repo <path>] [--folder <name>]

## Steps

1. Find the notes repository: `--repo`, else the one the user's `CLAUDE.md` names as their notes repository, else ask once. It must be a git repository; read its `README.md` and `CLAUDE.md` for its folders, file naming, frontmatter and rules about what may not be saved. Those rules win over the defaults below.
2. Decide what to save: the argument, else the latest substantial result in the conversation (say which). Pick the folder by what it is, unless `--folder` says otherwise:
   - `ideas/`: something to build or try;
   - `analyses/`: research, comparisons, evaluations, with sources;
   - `artifacts/<slug>/`: a file meant to be opened (a page, a deck, a diagram), plus a `README.md` saying what it is;
   - `notes/`: everything else worth keeping, such as learnings, how-tos and decisions;
   - `inbox/`: when unsure.
3. Write it self-contained: someone reading it in a year, without this conversation, understands the context, the content and why it mattered. Keep the substance; drop the back-and-forth. Sources as links.
4. Remove what may not leave its context: secrets, credentials, personal data, and any client, employer or colleague confidential material (names, data, code, contracts, prices, internal documents). Rewrite such content as the user's own generic idea or learning. If that is not possible without losing the point, stop and ask.
5. Name it `YYYY-MM-DD-<slug>.md` (slug: two to five lowercase words). Add frontmatter in the repository's format, or by default: `title`, `date`, `type` (the folder), `tags`, `source` (where it came from, in general terms).
6. Show the path and the first lines, then commit `<folder>: add <slug>` and push to the repository's default branch, unless its rules say otherwise. Report the path and the commit.

## Rules

- One note per idea; never append to an unrelated note.
- Never overwrite an existing file; add a suffix to the slug instead.
- If the push fails, keep the local commit and report the error; do not force anything.

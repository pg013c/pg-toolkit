---
name: new-command
description: Add one or more /pg:* commands to this toolkit from a plain description of what each should do - propose a name and a paraphrase of each goal for your approval, write the skills, update README and CHANGELOG, run the checks, commit on a branch and open a pull request to main. Use from any repository whenever you want a new pg command; the argument is only what the command should do.
argument-hint: "<what the command should do; several commands as a list or separated by ;>"
---

# /pg:new-command <what it should do>

The argument describes the behaviour only. Where the toolkit lives, how a skill is written and how the change is shipped are this command's job.

## Steps

1. Find the toolkit. It is the folder this plugin is installed from: `${CLAUDE_PLUGIN_ROOT}` is its `plugins/pg`, so the repository root is two levels up. If that is not set, read `installLocation` of the `pg-toolkit` entry in `~/.claude/plugins/known_marketplaces.json`. Confirm the root is a git repository with `.claude-plugin/marketplace.json`, then read its `CLAUDE.md`, `README.md` and two or three skills in `plugins/pg/skills/` for structure and tone.
2. Work in a new worktree, never in that folder: it is the live install and may have another branch checked out. `git -C <root> fetch origin`, then `git -C <root> worktree add <temp dir>/pg-toolkit-<branch> -b <branch> origin/main`. Branch: `feat/<command-name>`, or `feat/<first>-and-<second>` for two, or `feat/new-commands-<topic>` for more.
3. Split the argument into commands, one per distinct job. For each draft:
   - a short kebab-case name that does not clash with an existing folder in `plugins/pg/skills/`;
   - its goal, paraphrased in your own words: what it does, from what input, with what result, and what it changes or sends;
   - the argument it takes (`argument-hint`).
4. Show the drafts and ask the user to confirm each name and whether the paraphrase matches what they meant. Write nothing until they do. Take their corrections and show the changed draft again until both are accepted. If something essential is still unclear, such as what the command may change or send, ask it here, one question at a time, with your recommended answer.
5. From the accepted drafts, decide the rest: a description that says what the command does and when to use it, so it triggers on the right requests, and its steps, reads, writes and side effects. Record the decisions you make for the pull request.
6. Write `plugins/pg/skills/<name>/SKILL.md` the way the existing skills are written: frontmatter (`name` equal to the folder, `description`, `argument-hint`), a `# /pg:<name> <args>` heading, a short intro when needed, numbered `## Steps`, and `## Rules`. Plain, short English.
7. Keep each command generic, because the repository is public:
   - no people, clients, employers, internal systems, emails, tokens or paths from other projects; examples use made-up names;
   - it works in any repository and reads project facts from the project;
   - it names outside tools by capability ("a connected Slack integration", "`gh`") and says what to do when one is missing;
   - actions that send, publish, push, deploy or delete wait for the user's explicit yes, unless the description asks otherwise.
   A command that also needs an agent, hook or template follows `CLAUDE.md`; hook changes are test-first.
8. Update the docs: a row per command in the README "Commands" table, the skill count in the README "Check it" line, and one line per command in `CHANGELOG.md` under `## Unreleased` (add that heading above the latest release if it is missing). Leave the version in `plugin.json` alone: a release is its own `chore: release x.y.z` commit.
9. Run `scripts/check.sh` in the worktree and fix what fails. Then read the whole diff once more for anything step 7 forbids.
10. Commit one command at a time, its skill with its README and CHANGELOG lines: `feat(skills): add /pg:<name>`.
11. Push the branch (`git push -u origin <branch>`) and open a pull request to `main` with `gh pr create --base main`: what each command does, an example call for each, the decisions you made in step 5, and the checks that passed. Running this command is the go-ahead for this push and pull request; nothing else is pushed, and nothing is merged.
12. Remove the worktree (`git -C <root> worktree remove <path>`); the branch stays. Report the pull request link and the new commands. They become available in a new session once the pull request is merged and the toolkit folder is on the updated `main`.

## Rules

- Change only what the new commands need. Ideas for other commands go into the report as suggestions.
- Without `gh` or a remote, stop after the commits and give the user the branch name and the commands to push and open the pull request.

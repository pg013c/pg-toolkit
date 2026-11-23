---
name: cleanup
description: Find stale local git branches and worktrees - merged, gone from the remote, or untouched for N days - list them with their state and what would be lost, and delete only what the user approves. Remote branches are only listed, never deleted unless the user names them. Use when branches and worktrees have piled up.
argument-hint: "[--days <n>] [--base <branch>]"
---

# /pg:cleanup [--days <n>] [--base <branch>]

## Steps

1. `git fetch --prune`. The base is `--base`, else the main branch from `CLAUDE.md`, else `origin/main`. The age limit is `--days`, default 30.
2. List local branches, except the current one and the base, with: last commit date, whether it is merged into the base (`git branch --merged`, and for squash merges whether its changes are already in the base), whether its upstream is gone, commits not on any remote, and whether a worktree uses it.
3. List worktrees (`git worktree list`) with their branch, whether the folder still exists, and uncommitted changes.
4. Group into:
   - **safe**: merged, or upstream gone with no unpushed commits, and no worktree with changes;
   - **check**: older than the limit but not merged, or with unpushed commits; show what would be lost (commit count and subjects);
   - **keep**: recent and unmerged.
   Remote branches that are merged are shown in a separate list for information.
5. Ask which groups or items to remove. Delete only those: `git worktree remove` (never with uncommitted changes unless the user names that worktree), `git worktree prune`, then `git branch -d`, or `-D` only for an item the user approved knowing what is lost.
6. Report what was removed and what is left. Deleted branch tips are printed with their commit ids so they can be restored with `git branch <name> <sha>`.

## Rules

- Never delete the current branch, the base, or remote branches unless the user names them.
- Nothing is removed without approval; an approval covers only the items listed.

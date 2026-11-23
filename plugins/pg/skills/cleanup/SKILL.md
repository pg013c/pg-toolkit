---
name: cleanup
description: Find stale local git branches and worktrees - merged, gone from the remote, or untouched for N days - list them with their state and what would be lost, and delete only what the user approves. Remote branches are only listed, never deleted unless the user names them. Use when branches and worktrees have piled up.
argument-hint: "[--days <n>] [--base <branch>]"
---

# /pg:cleanup [--days <n>] [--base <branch>]

## Steps

1. If `git remote` is empty, skip the fetch and say that upstream and unpushed checks are skipped. Otherwise `git fetch --prune`; if it fails, report it and continue on local data. The base is `--base`, else the main branch from `CLAUDE.md`, else `origin/main` (the local `main` without a remote). The age limit is `--days`, default 30.
2. List local branches, except the current one and the base, with: last commit date; whether it is merged into the base (its tip equals or is an ancestor of the base; for squash merges, `git cherry <base> <branch>` shows only `-` lines, or `git diff --quiet <base> <branch> -- <files the branch changed>`); whether its upstream is gone; commits not on any remote (`git log <branch> --not --remotes`; without a remote, commits not in the base); and whether a worktree uses it.
3. List worktrees (`git worktree list`) with their branch, whether the folder still exists, and uncommitted changes (`git -C <path> status --porcelain`, untracked files included).
4. Group into:
   - **safe**: merged, or upstream gone with no unpushed commits, and no worktree with changes;
   - **check**: older than the limit and not merged; show what would be lost (commit count and subjects);
   - **keep**: within the limit and not merged, or used by a worktree with changes, whatever its age.
   Unpushed commits are shown as data, not used to pick the group. With a remote, merged remote branches are shown in a separate list for information.
5. Ask which groups or items to remove. Delete only those, worktrees first: `git worktree remove` (never with uncommitted changes unless the user names that worktree), `git worktree prune`, then the branches: `git branch -d` when the base is checked out, otherwise `-D` for items confirmed merged into the base, and `-D` for an unmerged item only when the user approved it knowing what is lost.
6. Report what was removed and what is left. Print each deleted branch with its full commit id, so it can be restored with `git branch <name> <sha>`.

## Rules

- Never delete the current branch, the base, or remote branches unless the user names them.
- Nothing is removed without approval; an approval covers only the items listed.

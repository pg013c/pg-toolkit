#!/usr/bin/env bash
# PreToolUse hook (Bash): in a pg project, refuses force pushes, pushes to the main branch and merging
# pull requests. A line in .pg/allow lifts a rule: force-push, push-main, merge.
set -uo pipefail

root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
[[ -d "$root/.pg" ]] || exit 0
# shellcheck source=plugins/pg/hooks/lib/commands.sh
source "$(dirname "$0")/lib/commands.sh"

if ! command -v jq >/dev/null; then
  echo "pg git-guard: jq is not installed, git commands are not checked." >&2
  exit 1
fi

cmd="$(jq -r '.tool_input.command // empty')"
[[ -n "$cmd" ]] || exit 0
allowed="$(read_list "$root/.pg/allow")"
allows() { grep -qx "$1" <<<"$allowed"; }

refuse() {
  echo "pg git-guard: $1" >&2
  echo "The human does this step. To allow it in this repository, add '$2' to .pg/allow." >&2
  exit 2
}

current_branch() { git -C "$root" symbolic-ref --quiet --short HEAD 2>/dev/null; }
is_main() { [[ "$1" == "main" || "$1" == "master" ]]; }

while IFS= read -r seg; do
  if [[ "$seg" =~ ^gh[[:space:]]+pr[[:space:]]+merge([[:space:]]|$) ]] && ! allows merge; then
    refuse "merging a pull request is refused." merge
  fi
  [[ "$seg" =~ ^git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+push([[:space:]]|$) ]] || continue
  # shellcheck disable=SC2206
  words=($seg)
  args=()
  seen_push=0
  for w in "${words[@]}"; do
    if [[ $seen_push -eq 1 ]]; then args+=("$w"); elif [[ "$w" == "push" ]]; then seen_push=1; fi
  done
  positional=()
  for a in ${args[@]+"${args[@]}"}; do
    if [[ "$a" == --force* || "$a" =~ ^-[A-Za-z]*f[A-Za-z]*$ ]]; then
      allows force-push || refuse "force push is refused ($seg)." force-push
    elif [[ "$a" != -* ]]; then
      positional+=("$a")
    fi
  done
  # positional[0] is the remote; the rest are refspecs.
  for p in ${positional[@]+"${positional[@]:1}"}; do
    [[ "$p" == +* ]] && ! allows force-push && refuse "force push is refused ($seg)." force-push
    target="${p#+}"
    target="${target##*:}"
    is_main "$target" && ! allows push-main && refuse "pushing to $target is refused ($seg)." push-main
  done
  if [[ ${#positional[@]} -le 1 ]] && is_main "$(current_branch)" && ! allows push-main; then
    refuse "pushing while on $(current_branch) is refused ($seg)." push-main
  fi
done < <(split_segments "$cmd")
exit 0

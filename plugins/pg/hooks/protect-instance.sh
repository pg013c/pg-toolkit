#!/usr/bin/env bash
# PreToolUse hook (Bash): in a pg project, refuses commands that would stop or change the instance the user
# works with, as listed in .pg/protected, one per line:
#   port <number>       killing whatever listens on it
#   path <directory>    removing or moving it or anything inside it (~ is expanded)
#   command <pattern>   running a command that matches the shell pattern, e.g. "pnpm app:*"
set -uo pipefail

root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
list="$root/.pg/protected"
[[ -f "$list" ]] || exit 0
# shellcheck source=plugins/pg/hooks/lib/commands.sh
source "$(dirname "$0")/lib/commands.sh"

if ! command -v jq >/dev/null; then
  echo "pg protect-instance: jq is not installed, the protected instance is not guarded." >&2
  exit 1
fi

cmd="$(jq -r '.tool_input.command // empty')"
[[ -n "$cmd" ]] || exit 0

refuse() {
  echo "pg protect-instance: $1" >&2
  echo "This is the instance the user works with (.pg/protected). Use a throwaway data directory and a free port instead, or ask the user." >&2
  exit 2
}

kills=0
if grep -Eq '(^|[^[:alnum:]_-])(kill|pkill|killall|kill-port)([^[:alnum:]_-]|$)|fuser[^|;&]*-k' <<<"$cmd"; then kills=1; fi

segments="$(split_segments "$cmd")"
while IFS= read -r line; do
  kind="${line%%[[:space:]]*}"
  value="${line#"$kind"}"
  value="${value#"${value%%[![:space:]]*}"}"
  case "$kind" in
    port)
      if [[ $kills -eq 1 ]] && grep -Eq "(:|[[:space:]])${value}(/tcp|/udp)?([^0-9]|$)" <<<"$cmd"; then
        refuse "the command would stop whatever listens on port $value."
      fi ;;
    path)
      value="${value/#\~/$HOME}"
      value="${value%/}"
      while IFS= read -r seg; do
        if [[ "$seg" =~ ^(sudo[[:space:]]+)?(rm|mv|rmdir|truncate|shred)[[:space:]] ]]; then
          # shellcheck disable=SC2206
          words=($seg)
          for w in "${words[@]:1}"; do
            w="${w/#\~/$HOME}"
            [[ "$w" == "$value" || "$w" == "$value"/* ]] && refuse "the command would remove or move $value."
          done
        fi
      done <<<"$segments"
      ;;
    command)
      while IFS= read -r seg; do
        # shellcheck disable=SC2053
        [[ "$seg" == ${value} || "$seg" == ${value}[[:space:]]* ]] && refuse "'$value' is a protected command."
      done <<<"$segments"
      ;;
  esac
done < <(read_list "$list")
exit 0

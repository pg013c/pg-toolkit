#!/usr/bin/env bash
# Helpers for hooks that look at Bash commands.

# split_segments <command> : prints each simple command on its own line, split at ;, &&, ||, | and newlines,
# with leading environment assignments and whitespace removed. Quoted text is not parsed; segments that
# only mention a command inside quotes do not start with it, so they are not matched.
split_segments() {
  printf '%s\n' "$1" | sed -E 's/(\|\||&&|;|\|)/\n/g' | sed -E 's/^[[:space:]]+//; s/^([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)+//'
}

# read_list <file> : prints the file's non-empty lines without comments and surrounding whitespace.
read_list() {
  [[ -f "$1" ]] || return 0
  sed -E 's/#.*//; s/^[[:space:]]+//; s/[[:space:]]+$//' "$1" | grep -v '^$' || true
}

#!/usr/bin/env bash
# Release helper, see Versioning in CLAUDE.md.
#   scripts/release.sh prepare <x.y.z>   on the pull request branch: bump plugin.json, date the Unreleased
#                                        changelog section, commit "chore: release x.y.z"
#   scripts/release.sh publish           on main after the merge: tag the release commit vX.Y.Z, push the
#                                        tag and publish a GitHub release with that changelog section
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
manifest=plugins/pg/.claude-plugin/plugin.json

die() { echo "release: $1" >&2; exit 1; }

case "${1:-}" in
  prepare)
    version="${2:-}"
    [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "usage: release.sh prepare <x.y.z>"
    [[ -z "$(git status --porcelain)" ]] || die "the working tree is not clean"
    current="$(jq -r .version "$manifest")"
    [[ "$version" != "$current" ]] || die "plugin.json is already $version"
    awk '/^## Unreleased/{f=1;next} /^## /{f=0} f && NF' CHANGELOG.md | grep -q . || die "## Unreleased is empty"
    tmp="$(mktemp)"
    jq --arg v "$version" '.version = $v' "$manifest" > "$tmp" && mv "$tmp" "$manifest"
    today="$(date +%Y-%m-%d)"
    awk -v v="$version" -v d="$today" '!done && /^## Unreleased$/ {print; print ""; print "## " v " (" d ")"; done=1; next} {print}' \
      CHANGELOG.md > "$tmp" && mv "$tmp" CHANGELOG.md
    git commit -qam "chore: release $version"
    echo "Committed chore: release $version ($current -> $version)."
    ;;
  publish)
    [[ "$(git rev-parse --abbrev-ref HEAD)" == "main" ]] || die "switch to main first"
    git pull -q --ff-only
    version="$(jq -r .version "$manifest")"
    tag="v$version"
    git rev-parse -q --verify "refs/tags/$tag" >/dev/null && die "$tag already exists"
    commit="$(git log --format=%H --grep "^chore: release $version\$" -1)"
    [[ -n "$commit" ]] || die "no 'chore: release $version' commit on main"
    notes="$(mktemp)"
    awk -v v="$version" '$0 ~ "^## " v " " {f=1; next} /^## /{f=0} f' CHANGELOG.md > "$notes"
    git tag "$tag" "$commit"
    git push -q origin "$tag"
    gh release create "$tag" --title "$tag" --notes-file "$notes"
    rm -f "$notes"
    ;;
  *)
    die "usage: release.sh prepare <x.y.z> | publish"
    ;;
esac

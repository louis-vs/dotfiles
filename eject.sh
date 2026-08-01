#!/usr/bin/env bash
#
# Replace a package's symlinks in $HOME with the real files and remove the
# repo's copy — the inverse of `stow --adopt`. Invoked by `make eject`.
#
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"
dry="${DRY:-}"

[ $# -gt 0 ] || { echo "usage: make eject packages=<pkg> [dry=1]" >&2; exit 2; }

run() {
  if [ -n "$dry" ]; then
    echo "  would: $*"
  else
    "$@"
  fi
}

# stow --dotfiles maps a leading `dot-` in any path component onto `.`. Anchor
# every component with a slash so one plain BSD-compatible substitution does it.
target_of() {
  echo "$HOME$(echo "/$1" | sed 's|/dot-|/.|g')"
}

owned="$(mktemp)"
trap 'rm -f "$owned"' EXIT

rc=0
for pkg in "$@"; do
  pkg="${pkg%/}"
  if [ ! -d "$repo/$pkg" ]; then
    echo "$pkg: no such package" >&2
    rc=1
    continue
  fi

  # Keep only the files $HOME currently resolves back to this package. Going
  # through readlink covers folded directory symlinks (~/bin) as well as
  # per-file links, and leaves anything stow doesn't own alone.
  : >"$owned"
  while IFS= read -r rel; do
    dst="$(target_of "$rel")"
    if [ "$(readlink -f "$dst" 2>/dev/null)" = "$(readlink -f "$repo/$pkg/$rel")" ]; then
      echo "$rel" >>"$owned"
    else
      echo "$pkg: leaving $rel, $dst is not linked into this repo" >&2
    fi
  done <<EOF
$(cd "$repo/$pkg" && find . -type f | sed 's|^\./||')
EOF

  if [ ! -s "$owned" ]; then
    echo "$pkg: nothing to eject" >&2
    rc=1
    continue
  fi

  echo "$pkg:"
  stow --dotfiles --dir="$repo" --target="$HOME" ${dry:+-n -v} --delete "$pkg"

  while IFS= read -r rel; do
    dst="$(target_of "$rel")"
    echo "  $rel -> $dst"
    run mkdir -p "$(dirname "$dst")"
    run mv "$repo/$pkg/$rel" "$dst"
  done <"$owned"

  run find "$repo/$pkg" -type d -empty -delete
done

exit $rc

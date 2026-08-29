#!/usr/bin/env bash
#
# Replace symlinks in $HOME with the real files and remove the repo's copy —
# the inverse of `stow --adopt`. Invoked by `make eject`.
#
# Each argument is either a package (eject all of it) or a path relative to
# stow/ naming one file inside a package (eject just that file).
#
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"
stow_dir="$repo/stow"
dry="${DRY:-}"

[ $# -gt 0 ] || { echo "usage: make eject packages=<pkg>|paths=<pkg/file> [dry=1]" >&2; exit 2; }

run() {
  if [ -n "$dry" ]; then
    echo "  would: $*"
  else
    "$@"
  fi
}

stow_do() {
  stow --dotfiles --dir="$stow_dir" --target="$HOME" "$@"
}

# stow --dotfiles maps a leading `dot-` in any path component onto `.`. Anchor
# every component with a slash so one plain BSD-compatible substitution does it.
target_of() {
  echo "$HOME$(echo "/$1" | sed 's|/dot-|/.|g')"
}

# find, not fd: fd skips hidden and gitignored files by default, and packages
# are mostly dotfiles (dot-config/nvim/.neoconf.json and friends).
files_in() {
  (cd "$1" && find . -type f | sed 's|^\./||')
}

owned="$(mktemp)"
trap 'rm -f "$owned"' EXIT

rc=0
for arg in "$@"; do
  arg="${arg%/}"
  if [ -d "$stow_dir/$arg" ]; then
    pkg="$arg"
    candidates="$(files_in "$stow_dir/$pkg")"
    whole=1
  elif [ -f "$stow_dir/$arg" ] && [ "${arg%%/*}" != "$arg" ]; then
    pkg="${arg%%/*}"
    candidates="${arg#*/}"
    whole=
  else
    echo "$arg: not a package, and not a file inside one" >&2
    rc=1
    continue
  fi

  # Keep only the files $HOME currently resolves back to this package. Going
  # through readlink covers folded directory symlinks (~/bin) as well as
  # per-file links, and leaves anything stow doesn't own alone.
  : >"$owned"
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    dst="$(target_of "$rel")"
    if [ "$(readlink -f "$dst" 2>/dev/null)" = "$(readlink -f "$stow_dir/$pkg/$rel")" ]; then
      echo "$rel" >>"$owned"
    else
      echo "$pkg: leaving $rel, $dst is not linked into this repo" >&2
    fi
  done <<EOF
$candidates
EOF

  if [ ! -s "$owned" ]; then
    echo "$arg: nothing to eject" >&2
    rc=1
    continue
  fi

  # Unstow the whole package even when ejecting one file: under tree folding
  # the file has no symlink of its own, only an ancestor directory does.
  echo "$arg:"
  stow_do ${dry:+-n} --delete "$pkg"

  while IFS= read -r rel; do
    dst="$(target_of "$rel")"
    echo "  $rel -> $dst"
    run mkdir -p "$(dirname "$dst")"
    run mv "$stow_dir/$pkg/$rel" "$dst"
  done <"$owned"

  run find "$stow_dir/$pkg" -type d -empty -delete

  # Re-link the files we did not eject. Only for a single path — a whole
  # package eject is meant to leave nothing linked, and restowing it would
  # link files stow had skipped. The ejected file is now real content in the
  # target directory, so stow can no longer fold that directory away.
  if [ -z "$whole" ]; then
    if [ -n "$dry" ]; then
      echo "  would: restow $pkg to re-link its remaining files"
    elif [ -d "$stow_dir/$pkg" ]; then
      stow_do --restow "$pkg"
    fi
  fi
done

exit $rc

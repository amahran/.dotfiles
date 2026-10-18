#!/usr/bin/env bash
# Link the dotfiles into $HOME with GNU Stow.
#
#   ./stow.sh                 stow the default package list
#   ./stow.sh tmux hypr       stow only these packages
#   ./stow.sh --check         dry run: show what would be backed up / linked
#
# Anything already in the way is moved to ~/.dotfiles-backup/<timestamp>/ first,
# never deleted.
# Safe to re-run at any time.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${STOW_TARGET:-$HOME}"
BACKUP="${STOW_BACKUP:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"

# Packages to be stowed.
DEFAULT_PACKAGES=(zsh git tmux kitty zathura mbake bin nvim hypr omarchy)

# Packages whose top-level directory is replaced as a whole (one symlink to the
# directory) instead of file-by-file.
declare -A FOLDED=([nvim]=".config/nvim")

CHECK=0
packages=()
for arg in "$@"; do
  case "$arg" in
    --check | -n) CHECK=1 ;;
    -h | --help) sed -n '2,11p' "$0"; exit 0 ;;
    *) packages+=("$arg") ;;
  esac
done
((${#packages[@]})) || packages=("${DEFAULT_PACKAGES[@]}")

command -v stow >/dev/null || { echo "stow is not installed (sudo pacman -S stow)" >&2; exit 1; }

say() { printf '  %s\n' "$*"; }

# Move whatever is at $TARGET/$1 into the backup folder (or just report it).
backup() {
  local rel="$1"
  if ((CHECK)); then
    say "would back up ~/$rel"
    return
  fi
  mkdir -p "$BACKUP/$(dirname "$rel")"
  mv -- "$TARGET/$rel" "$BACKUP/$rel"
  say "backed up ~/$rel -> ${BACKUP/#$HOME/\~}/$rel"
}

# True if $1 (a path in $TARGET) is a symlink that resolves to $2.
links_to() {
  [[ -L $1 ]] && [[ "$(readlink -f -- "$1")" == "$(readlink -f -- "$2")" ]]
}

# Read the package's .stow-local-ignore patterns (basename regexes).
ignore_patterns() {
  local file="$DOTFILES/$1/.stow-local-ignore"
  [[ -f $file ]] || return 0
  grep -vE '^\s*(#|$)' "$file" || true
}

is_ignored() {
  local name="$1"; shift
  local pattern
  for pattern in "$@"; do
    [[ $name =~ ^${pattern}$ ]] && return 0
  done
  return 1
}

clear_conflicts() {
  local pkg="$1" rel src

  if [[ -n ${FOLDED[$pkg]:-} ]]; then
    rel="${FOLDED[$pkg]}"
    src="$DOTFILES/$pkg/$rel"
    if [[ -e $TARGET/$rel || -L $TARGET/$rel ]] && ! links_to "$TARGET/$rel" "$src"; then
      backup "$rel"
    fi
    return
  fi

  local -a patterns
  mapfile -t patterns < <(ignore_patterns "$pkg")

  while IFS= read -r -d '' src; do
    rel="${src#"$DOTFILES/$pkg/"}"
    is_ignored "$(basename "$rel")" "${patterns[@]}" ".stow-local-ignore" && continue
    if [[ -e $TARGET/$rel || -L $TARGET/$rel ]] && ! links_to "$TARGET/$rel" "$src"; then
      backup "$rel"
    fi
  done < <(find "$DOTFILES/$pkg" \( -type f -o -type l \) -not -path '*/.git/*' -not -name '.git' -print0)
}

for pkg in "${packages[@]}"; do
  if [[ ! -d $DOTFILES/$pkg ]]; then
    echo "skip $pkg (no such package)" >&2
    continue
  fi
  if [[ $pkg == nvim && ! -e $DOTFILES/nvim/.config/nvim/init.lua ]]; then
    echo "nvim submodule is empty; run: git -C \"$DOTFILES\" submodule update --init" >&2
    exit 1
  fi

  echo "$pkg"
  clear_conflicts "$pkg"

  stow_args=(--dir "$DOTFILES" --target "$TARGET" --restow)
  [[ -z ${FOLDED[$pkg]:-} ]] && stow_args+=(--no-folding)
  if ((CHECK)); then
    # Conflicts are expected here: nothing was actually moved out of the way.
    stow "${stow_args[@]}" --no --verbose=1 "$pkg" 2>&1 | sed 's/^/  /' || true
  else
    stow "${stow_args[@]}" "$pkg"
  fi
done

if ((!CHECK)) && [[ -d $BACKUP ]]; then
  echo
  echo "Replaced files were saved in ${BACKUP/#$HOME/\~}"
fi

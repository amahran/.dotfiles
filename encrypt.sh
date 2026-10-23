#!/usr/bin/env bash
# Re-encrypt the secrets in secrets/ from the live files, e.g. after rotating
# a key. Asks for a passphrase (age -p); bootstrap.sh's ssh_keys task asks for
# it again to decrypt. Commit the updated secrets/*.age afterwards.
#
#   ./encrypt.sh

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Files from ~/.ssh that go into secrets/ssh.tar.age. Work keys and
# config.d/ belong to the work repo; known_hosts isn't needed.
SSH_FILES=(github github.pub)

die() { printf '\033[31m%s\033[0m\n' "$*" >&2; exit 1; }

command -v age >/dev/null || die "age is not installed (sudo pacman -S age)"

paths=()
for f in "${SSH_FILES[@]}"; do
  [[ -f $HOME/.ssh/$f ]] || die "Missing ~/.ssh/$f (update SSH_FILES in $0?)"
  paths+=(".ssh/$f")
done

mkdir -p "$DOTFILES/secrets"
out="$DOTFILES/secrets/ssh.tar.age"
echo "Encrypting ${paths[*]} -> secrets/ssh.tar.age"
tar -C "$HOME" -c "${paths[@]}" | age -p -o "$out.new"
mv -- "$out.new" "$out"
echo "Done. Check with: age -d $out | tar -t"

#!/usr/bin/env bash
#
# Safely update Oh My Zsh when ~/.oh-my-zsh/custom is a symlink into this
# dotfiles repo.
#
# omz update's underlying `git checkout`/`git pull --rebase` fails with:
#   error: 'custom/example.zsh' is beyond a symbolic link
# because ~/.oh-my-zsh/custom is a symlink pointing outside the oh-my-zsh
# repo, and Git refuses to write through it. (ohmyzsh/ohmyzsh#10928)
#
# Fix: unlink `custom` before updating, let Git check out its own
# custom/ dir normally, run the update, then restore the symlink.

set -euo pipefail

OMZ_DIR="${ZSH:-$HOME/.oh-my-zsh}"
CUSTOM_LINK="$OMZ_DIR/custom"
CUSTOM_TARGET=""

cleanup() {
  if [ -n "$CUSTOM_TARGET" ] && [ ! -L "$CUSTOM_LINK" ]; then
    rm -rf "$CUSTOM_LINK"
    ln -s "$CUSTOM_TARGET" "$CUSTOM_LINK"
    echo "✓ Restored custom symlink -> $CUSTOM_TARGET"
  fi
}
trap cleanup EXIT

if [ -L "$CUSTOM_LINK" ]; then
  CUSTOM_TARGET="$(readlink "$CUSTOM_LINK")"
  echo "→ Unlinking custom (target: $CUSTOM_TARGET)"
  rm "$CUSTOM_LINK"
else
  echo "→ $CUSTOM_LINK is not a symlink, nothing to back up"
fi

echo "→ Updating Oh My Zsh..."
# Call upgrade.sh directly instead of `omz update` — this is what the OMZ
# maintainers recommend for scripted/automated updates anyway.
zsh "$OMZ_DIR/tools/upgrade.sh"

echo "→ Done."
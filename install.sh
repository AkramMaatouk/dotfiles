#!/usr/bin/env bash
# =============================================================================
# install.sh — Dotfiles bootstrap & sync
# Safe to run multiple times (idempotent).
# On every run it backs up any real files it would overwrite, then symlinks.
# =============================================================================

set -euo pipefail

# ─────────────────────────────────────────────
# Config
# DOTFILES_DIR: absolute path to this repo.
# BACKUP_DIR:   timestamped folder for any files we displace.
# ─────────────────────────────────────────────
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────

# Print a section header
section() { echo; echo "── $1 ──"; }

# safe_link <source_in_repo> <link_target_on_disk>
#
# Rules:
#   1. If the target is already a symlink pointing at our source → skip (idempotent).
#   2. If the target is a real file or directory → back it up, then link.
#   3. If the target does not exist → link directly.
safe_link() {
  local src="$1"
  local dst="$2"

  # Skip if already correctly linked
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "  [skip]   $dst → already linked"
    return
  fi

  # Back up any real (non-symlink) file or directory that is in the way
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "  [backup] $dst → $BACKUP_DIR/"
    mv "$dst" "$BACKUP_DIR/"
  fi

  # Remove a stale or wrong symlink
  [ -L "$dst" ] && rm "$dst"

  # Ensure the parent directory exists
  mkdir -p "$(dirname "$dst")"

  ln -s "$src" "$dst"
  echo "  [link]   $dst → $src"
}

# ─────────────────────────────────────────────
# 1. Oh My Zsh
# ─────────────────────────────────────────────
section "Oh My Zsh"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "  Installing Oh My Zsh (unattended)..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
else
  echo "  [skip]   ~/.oh-my-zsh already present"
fi

# ─────────────────────────────────────────────
# 2. Zsh
# ~/.zshrc              → dotfiles/zsh/.zshrc
# ~/.oh-my-zsh/custom   → dotfiles/zsh/custom
# ─────────────────────────────────────────────
section "Zsh"

safe_link "$DOTFILES_DIR/zsh/.zshrc"   "$HOME/.zshrc"
safe_link "$DOTFILES_DIR/zsh/custom"   "$HOME/.oh-my-zsh/custom"

# ─────────────────────────────────────────────
# 3. Neovim
# ~/.config/nvim        → dotfiles/nvim
# ─────────────────────────────────────────────
section "Neovim"

safe_link "$DOTFILES_DIR/nvim"    "$HOME/.config/nvim"

# ─────────────────────────────────────────────
# 4. Tmux
# ~/.config/tmux        → dotfiles/tmux
# ─────────────────────────────────────────────
section "Tmux"

safe_link "$DOTFILES_DIR/tmux"    "$HOME/.config/tmux"


# ─────────────────────────────────────────────
# 6. Ghostty
# ~/.config/ghostty     → dotfiles/ghostty
# ─────────────────────────────────────────────
section "Ghostty"

safe_link "$DOTFILES_DIR/ghostty"   "$HOME/.config/ghostty"

# ─────────────────────────────────────────────
# 7. Starship
# ~/.config/starship.toml → dotfiles/starship/starship.toml
# Note: starship.toml is a single file at the root of ~/.config,
# not a directory — so we link the file directly, not the folder.
# ─────────────────────────────────────────────
section "Starship"

safe_link "$DOTFILES_DIR/starship/starship.toml"   "$HOME/.config/starship.toml"

# ─────────────────────────────────────────────
# 8. Secrets placeholder
# Creates ~/.config/zsh/secrets.zsh if it does not exist.
# This file is NOT tracked by git — put PG_PASSWORD etc. here.
# ─────────────────────────────────────────────
section "Secrets placeholder"

SECRETS_FILE="$HOME/.config/zsh/secrets.zsh"
if [ ! -f "$SECRETS_FILE" ]; then
  mkdir -p "$(dirname "$SECRETS_FILE")"
  cat > "$SECRETS_FILE" <<'EOF'
# ~/.config/zsh/secrets.zsh
# Machine-specific secrets — NOT tracked by git.
# Sourced automatically by zsh/custom/paths.zsh

# export PG_PASSWORD=your_password_here
EOF
  echo "  [create] $SECRETS_FILE (empty template)"
else
  echo "  [skip]   $SECRETS_FILE already exists"
fi

# ─────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────
section "Done"

if [ -d "$BACKUP_DIR" ]; then
  echo "  Backups written to: $BACKUP_DIR"
fi
echo "  Restart your shell or run: source ~/.zshrc"
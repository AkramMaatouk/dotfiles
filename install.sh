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

# Helpers
section() { echo; echo "── $1 ──"; }

# safe_link: create symlink from repo to target, backing up real files
safe_link() {
  local src="$1"
  local dst="$2"

  local parent
  parent="$(dirname "$dst")"

  # Skip if already correctly linked
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "  [skip]   $dst → already linked"
    return
  fi

  # Back up any real (non-symlink) file or directory that is in the way
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR" || {
      echo "  [warn]   couldn't create backup dir $BACKUP_DIR; trying with sudo"
      sudo mkdir -p "$BACKUP_DIR" && sudo chown -R "$USER":"$USER" "$BACKUP_DIR"
    }
    echo "  [backup] $dst → $BACKUP_DIR/"
    if ! mv "$dst" "$BACKUP_DIR/" 2>/dev/null; then
      echo "  [warn]   mv failed due to permissions; retrying with sudo"
      sudo mv "$dst" "$BACKUP_DIR/"
      sudo chown -R "$USER":"$USER" "$BACKUP_DIR"
    fi
  fi

  # Remove a stale or wrong symlink
  if [ -L "$dst" ]; then
    if ! rm "$dst" 2>/dev/null; then
      echo "  [warn]   rm failed due to permissions; retrying with sudo"
      sudo rm -f "$dst"
    fi
  fi

  # Ensure the parent directory exists and is writable
  if [ ! -d "$parent" ]; then
    if ! mkdir -p "$parent" 2>/dev/null; then
      echo "  [warn]   mkdir -p $parent failed; attempting with sudo and fixing ownership"
      sudo mkdir -p "$parent"
      sudo chown -R "$USER":"$USER" "$parent"
    fi
  else
    if [ ! -w "$parent" ]; then
      echo "  [warn]   $parent is not writable; attempting to fix ownership with sudo"
      sudo chown -R "$USER":"$USER" "$parent" || true
    fi
  fi

  # Create the symlink (try normal user first, fall back to sudo)
  if ! ln -s "$src" "$dst" 2>/dev/null; then
    echo "  [warn]   ln -s failed; retrying with sudo and fixing ownership"
    sudo ln -s "$src" "$dst"
    sudo chown -h "$USER":"$USER" "$dst" || true
  fi
  echo "  [link]   $dst → $src"
}

# Oh My Zsh
section "Oh My Zsh"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "  Installing Oh My Zsh (unattended)..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
else
  echo "  [skip]   ~/.oh-my-zsh already present"
fi

# Zsh
section "Zsh"

safe_link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
safe_link "$DOTFILES_DIR/zsh/custom" "$HOME/.oh-my-zsh/custom"

# Install plugins listed in plugins.txt into ~/.oh-my-zsh/custom/plugins
PLUGINS_FILE="$DOTFILES_DIR/plugins.txt"
if [ -f "$PLUGINS_FILE" ]; then
  echo; echo "── Zsh plugins ──"
  mkdir -p "$HOME/.oh-my-zsh/custom/plugins"
  while IFS= read -r line || [ -n "$line" ]; do
    # strip comments and trim
    url="$(printf '%s' "$line" | sed 's/#.*//' | xargs 2>/dev/null || printf '%s' "$line")"
    [ -z "$url" ] && continue
    case "$url" in
      http*://*) ;;
      *) echo "  [skip]   invalid url: $url"; continue ;;
    esac
    name="$(basename "$url" .git)"
    dest="$HOME/.oh-my-zsh/custom/plugins/$name"
    if [ -d "$dest" ]; then
      echo "  [skip]   $name → already present"
      continue
    fi
    echo "  [clone]  $name from $url"
    if ! git clone --depth 1 "$url" "$dest" 2>/dev/null; then
      echo "  [warn]   shallow clone failed, retrying full clone"
      if ! git clone "$url" "$dest"; then
        echo "  [error]  failed to clone $url"
      fi
    fi
  done < "$PLUGINS_FILE"
fi

# Neovim
section "Neovim"

safe_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Tmux
section "Tmux"

safe_link "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"

# Ghostty
section "Ghostty"

safe_link "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

# Starship
section "Starship"

safe_link "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# Secrets placeholder
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

# Local overrides placeholder
LOCALS_FILE="$HOME/.config/zsh/locals.zsh"
if [ ! -f "$LOCALS_FILE" ]; then
  mkdir -p "$(dirname "$LOCALS_FILE")"
  cat > "$LOCALS_FILE" <<'EOF'
# ~/.config/zsh/locals.zsh
# Machine-specific path overrides — NOT tracked by git.
# Example overrides:
# export FZF_BASE=/usr/local/bin/fzf
# export CHROME_EXECUTABLE=/usr/bin/google-chrome
# export GENYMOTION_PATH=/opt/genymobile/genymotion
# export FLUTTER_PATH="$HOME/develop/flutter/bin"
EOF
  echo "  [create] $LOCALS_FILE (template)"
else
  echo "  [skip]   $LOCALS_FILE already exists"
fi

# ─────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────
section "Done"

if [ -d "$BACKUP_DIR" ]; then
  echo "  Backups written to: $BACKUP_DIR"
fi
echo "  Restart your shell or run: source ~/.zshrc"
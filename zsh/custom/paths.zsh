# ─────────────────────────────────────────────
# Core PATH
# ─────────────────────────────────────────────
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# ─────────────────────────────────────────────
# pyenv
# ─────────────────────────────────────────────
export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# ─────────────────────────────────────────────
# nvm
# ─────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ]            && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ]   && \. "$NVM_DIR/bash_completion"

# ─────────────────────────────────────────────
# pnpm
# ─────────────────────────────────────────────
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ─────────────────────────────────────────────
# Pub (Dart / Flutter)
# ─────────────────────────────────────────────
export PATH="$PATH:$HOME/.pub-cache/bin"

# ─────────────────────────────────────────────
# Flutter
# ─────────────────────────────────────────────
export PATH="/home/akram/develop/flutter/bin:$PATH"

# ─────────────────────────────────────────────
# Android SDK
# ─────────────────────────────────────────────
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

# ─────────────────────────────────────────────
# Genymotion
# ─────────────────────────────────────────────
export PATH="/opt/genymobile/genymotion:$PATH"

# ─────────────────────────────────────────────
# Browser
# ─────────────────────────────────────────────
export CHROME_EXECUTABLE=/usr/bin/brave-browser

# ─────────────────────────────────────────────
# OpenSSL (system pkg-config / linker)
# ─────────────────────────────────────────────
export PKG_CONFIG_PATH="/usr/bin/openssl/lib/pkgconfig:$PKG_CONFIG_PATH"
export LD_LIBRARY_PATH="/usr/bin/openssl/lib:$LD_LIBRARY_PATH"

# ─────────────────────────────────────────────
# rbenv
# ─────────────────────────────────────────────
eval "$(~/.rbenv/bin/rbenv init - --no-rehash zsh)"

# ─────────────────────────────────────────────
# PostgreSQL credentials
# Keep secrets out of git — set these in ~/.config/zsh/secrets.zsh
# and source that file here if it exists
# ─────────────────────────────────────────────
export PG_USER=postgres
# export PG_PASSWORD=   ← put this in ~/.config/zsh/secrets.zsh (not tracked)
[ -f "$HOME/.config/zsh/secrets.zsh" ] && source "$HOME/.config/zsh/secrets.zsh"

# ─────────────────────────────────────────────
# SDKMAN — must stay at the end of this file
# ─────────────────────────────────────────────
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

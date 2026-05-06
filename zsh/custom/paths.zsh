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
[ -s "$NVM_DIR/nvm.sh" ]          && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

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
# Fuzzy Finder
# ─────────────────────────────────────────────
FZF_BASE=/usr/bin/fzf  

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
# OpenSSL (pkg-config / linker)
# Fixed: /usr/bin/openssl is the binary, not a lib dir.
# System OpenSSL headers live in /usr/lib/pkgconfig.
# ─────────────────────────────────────────────
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
# LD_LIBRARY_PATH for OpenSSL is not normally needed on Linux;
# the system linker finds it via ldconfig. Remove if you had no
# specific reason for it — it can mask linker issues.
# export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"

# ─────────────────────────────────────────────
# rbenv
# ─────────────────────────────────────────────
eval "$(~/.rbenv/bin/rbenv init - --no-rehash zsh)"

# ─────────────────────────────────────────────
# PostgreSQL credentials
# PG_USER is fine to export here.
# Keep PG_PASSWORD in ~/.config/zsh/secrets.zsh (not tracked by git).
# ─────────────────────────────────────────────
export PG_USER=postgres
[ -f "$HOME/.config/zsh/secrets.zsh" ] && source "$HOME/.config/zsh/secrets.zsh"

# ─────────────────────────────────────────────
# SDKMAN — must stay at the end of this file
# ─────────────────────────────────────────────
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
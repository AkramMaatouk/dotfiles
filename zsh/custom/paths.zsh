# ─────────────────────────────────────────────
# Core PATH is set in ~/.zshrc (non-machine-specific)
# ─────────────────────────────────────────────

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
  *":$PNPM_HOME:") ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ─────────────────────────────────────────────
# Pub (Dart / Flutter)
# ─────────────────────────────────────────────
export PATH="$PATH:$HOME/.pub-cache/bin"

# Flutter (set `FLUTTER_PATH` in ~/.config/zsh/locals.zsh if present)
if [ -n "${FLUTTER_PATH:-}" ]; then
  export PATH="$FLUTTER_PATH:$PATH"
fi

# ─────────────────────────────────────────────
# Fuzzy Finder (override in locals if needed)
# ─────────────────────────────────────────────
FZF_BASE="${FZF_BASE:-/usr/bin/fzf}"

# ─────────────────────────────────────────────
# Android SDK
# ─────────────────────────────────────────────
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

# ─────────────────────────────────────────────
# Genymotion
GENYMOTION_PATH="${GENYMOTION_PATH:-/opt/genymobile/genymotion}"
export PATH="$GENYMOTION_PATH:$PATH"

# ─────────────────────────────────────────────
# Browser (binary to launch when needed)
CHROME_EXECUTABLE="${CHROME_EXECUTABLE:-/usr/bin/brave-browser}"

# ─────────────────────────────────────────────
# OpenSSL (pkg-config / linker)
# Fixed: /usr/bin/openssl is the binary, not a lib dir.
# System OpenSSL headers live in /usr/lib/pkgconfig.
# ─────────────────────────────────────────────
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
# export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"

# ─────────────────────────────────────────────
# rbenv
# ─────────────────────────────────────────────
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - --no-rehash zsh)"
fi

# ─────────────────────────────────────────────
# cargo
# ─────────────────────────────────────────────
export PATH="$HOME/.cargo/bin:$PATH"

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


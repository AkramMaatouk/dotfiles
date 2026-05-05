# ─────────────────────────────────────────────
# Oh My Zsh core
# ─────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

zstyle ':omz:update' mode reminder
COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"

plugins=(git)

# Point OMZ at the symlinked custom directory
ZSH_CUSTOM=~/.oh-my-zsh/custom

source $ZSH/oh-my-zsh.sh

# ─────────────────────────────────────────────
# Source custom modules
# ─────────────────────────────────────────────
source $ZSH_CUSTOM/paths.zsh
source $ZSH_CUSTOM/aliases.zsh
source $ZSH_CUSTOM/battery.zsh

# ─────────────────────────────────────────────
# Tmux: auto-attach or create a session on terminal open
# Skipped when already inside tmux to prevent nesting
# ─────────────────────────────────────────────
if [ -z "$TMUX" ]; then
  tmux attach-session -t main 2>/dev/null || tmux new-session -s main
fi


eval "$(starship init zsh)"


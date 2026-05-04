# ─────────────────────────────────────────────
# Oh My Zsh core
# ─────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=random
ZSH_THEME_RANDOM_CANDIDATES=("robbyrussell" "awesomepanda")

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

# ─────────────────────────────────────────────
# SSH agent: persistent across tmux sessions
# Stores agent socket in ~/.ssh/agent-env
# ─────────────────────────────────────────────
SSH_ENV="$HOME/.ssh/agent-env"

_start_ssh_agent() {
  ssh-agent > "$SSH_ENV"
  chmod 600 "$SSH_ENV"
  source "$SSH_ENV" > /dev/null
  ssh-add ~/.ssh/gitub_ssh
}

if [ -f "$SSH_ENV" ]; then
  source "$SSH_ENV" > /dev/null
  kill -0 "$SSH_AGENT_PID" 2>/dev/null || _start_ssh_agent
else
  _start_ssh_agent
fi

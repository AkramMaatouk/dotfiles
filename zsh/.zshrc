# ─────────────────────────────────────────────
# Oh My Zsh core
# ─────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""   # Managed by Starship

zstyle ':omz:update' mode reminder
COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"

# Install zsh-autosuggestions & zsh-syntax-highlighting if not present:
#   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#   git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
plugins=(
  git
  fzf     # fuzzy finder keybindings (ctrl+r, ctrl+t, alt+c)
  colorize 
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-autocomplete                
)

ZSH_CUSTOM=~/.oh-my-zsh/custom
source $ZSH/oh-my-zsh.sh

# ─────────────────────────────────────────────
# Source custom modules
# ─────────────────────────────────────────────
source $ZSH_CUSTOM/paths.zsh
source $ZSH_CUSTOM/aliases.zsh
source $ZSH_CUSTOM/battery.zsh

# ─────────────────────────────────────────────
# Tmux: auto-attach or create session on shell open
# Skipped when already inside tmux (prevents nesting)
# ─────────────────────────────────────────────
if [[ -z "$TMUX" ]]; then
  tmux attach-session -t main 2>/dev/null || tmux new-session -s main
fi

# ─────────────────────────────────────────────
# Starship prompt
# ─────────────────────────────────────────────
eval "$(starship init zsh)"


# ─────────────────────────────────────────────
# fzf Fuzzy Finder
# ─────────────────────────────────────────────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
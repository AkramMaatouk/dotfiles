# ─────────────────────────────────────────────
# Shell aliases
# ─────────────────────────────────────────────

# ── Zsh / Config ──────────────────────────────
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh ~/.zshrc"
alias zshrc="source ~/.zshrc"
alias dotfiles="code ~/dotfiles"

# ── System ────────────────────────────────────
alias bro="sudo"
alias shortcutconfig="code ~/.local/share/applications /usr/share/applications"

# ── Navigation ────────────────────────────────
alias workspace="cd ~/myWorkspace"
alias ..="cd .."
alias ...="cd ../.."

# ── Tmux ──────────────────────────────────────
alias ta="tmux attach-session -t"             # ta main
alias tls="tmux list-sessions"
alias tn="tmux new-session -s"                # tn mysession
alias tk="tmux kill-session -t"               # tk mysession
alias tconf="code ~/.config/tmux/tmux.conf"

# ── Git shortcuts ─────────────────────────────
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"

# ── Neovim ────────────────────────────────────
alias v="nvim"
alias vi="nvim"


# ── eza for listing ────────────────────────────────────
alias l='eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first'
alias ll='eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first -l --git -h'
alias la='eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first -a'
alias lla='eza --color=always --color-scale=all --color-scale-mode=gradient --icons=always --group-directories-first -a -l --git -h'
alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
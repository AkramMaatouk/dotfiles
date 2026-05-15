# dotfiles

Minimal, git-ready dotfiles for Linux — Zsh (Oh My Zsh), Neovim, Tmux.

---

## Structure

```
dotfiles/
├── install.sh          # bootstrap & sync script
├── .gitignore
├── README.md
├── zsh/
│   ├── .zshrc          # → ~/.zshrc
│   └── custom/         # → ~/.oh-my-zsh/custom/
│       ├── aliases.zsh
│       ├── paths.zsh
│       └── battery.zsh
├── nvim/
│   └── init.lua        # → ~/.config/nvim/
├── tmux/
│   └── tmux.conf       # → ~/.config/tmux/
```

---

## Install (fresh machine)

```bash
git clone https://github.com/<you>/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The script will:

1. Install **Oh My Zsh** if it isn't already present.
2. Back up any real files it would overwrite into `~/.dotfiles-backup/<timestamp>/`.
3. Create symbolic links from the repo into `~` and `~/.config/`.
4. Create `~/.config/zsh/secrets.zsh` as an untracked placeholder for passwords.

---

## Sync (existing machine)

Pull the latest changes and re-run the installer. It is fully idempotent — already-correct links are skipped, nothing is overwritten without a backup.

```bash
cd ~/dotfiles
git pull
./install.sh
```

---

## Secrets

Machine-specific credentials (e.g. `PG_PASSWORD`) belong in:

```
~/.config/zsh/secrets.zsh
```

This file is created automatically by `install.sh` but is **never tracked by git**. Add your variables there:

```bash
export PG_PASSWORD=your_password_here
```

It is sourced automatically at the bottom of `zsh/custom/paths.zsh`.

## Local path overrides

Machine-specific paths or binary locations (for example: custom Flutter installs, Brave/Chrome location, Genymotion, or FZF binary paths) should not live in the tracked `zsh/custom/paths.zsh` file. Put those overrides in:

```
~/.config/zsh/locals.zsh
```

The installer will create a small template for this file if it does not exist. `zsh/custom/paths.zsh` sources `~/.config/zsh/locals.zsh` so your overrides take precedence.

Example `~/.config/zsh/locals.zsh`:

```bash
# Local machine overrides (example)
export FZF_BASE=/usr/local/bin/fzf
export CHROME_EXECUTABLE=/usr/bin/google-chrome
export GENYMOTION_PATH=/opt/genymobile/genymotion
export FLUTTER_PATH="$HOME/develop/flutter/bin"
```

---

## Adding a new tool config

1. Create a folder in the repo: `mkdir mytool/`
2. Add your config file inside it.
3. Add a `safe_link` call in `install.sh`.
4. Re-run `./install.sh`.

---

## Tested on

- OS: Linux (Ubuntu / Arch)
- Shell: Zsh + Oh My Zsh
- Multiplexer: Tmux
- Editor: Neovim

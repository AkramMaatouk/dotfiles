# dotfiles

Minimal, git-ready dotfiles for Linux — Zsh (Oh My Zsh), Kitty, Neovim, Tmux, Pi Agent.

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
├── kitty/
│   └── kitty.conf      # → ~/.config/kitty/
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
- Terminal: Kitty
- Multiplexer: Tmux
- Editor: Neovim

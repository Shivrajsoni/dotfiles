# Dotfiles

```bash
git clone https://github.com/Shivrajsoni/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash bootstrap.sh
```

Detects macOS / Linux, installs packages, sets up dev tools (Node, Bun, Python, Rust, C++), symlinks configs. Existing configs are backed up to `~/dotfiles_backup_<timestamp>/`.

## Commands

```bash
make install    # full setup (packages, toolchain, macOS defaults, links)
make link       # re-symlink configs only (safe to re-run)
make update     # upgrade brew + tmux plugins
bash bootstrap.sh --dry-run    # preview every action
```

## Structure

```
├── home/                  # → $HOME: .zshrc, .bashrc, .tmux.conf
├── git/.gitconfig
├── config/                # → ~/.config
│   ├── shell/common.sh    # aliases, PATH, lazy nvm — shared by zsh + bash (not linked, sourced)
│   ├── starship/  wezterm/  fastfetch/
│   └── aerospace/  sketchybar/   # tiling WM + status bar (macOS)
├── scripts/               # lib.sh, dev-toolchain.sh, macos-defaults.sh, linux-packages.sh
├── obsidian/              # vault settings (manual copy)
├── Brewfile  Makefile  bootstrap.sh
```

AeroSpace's `gaps.outer.top` must clear the sketchybar (`BAR_Y_OFFSET + BAR_HEIGHT` in `config/sketchybar/variables.sh`). Change one, change the other.

## Machine-specific overrides

Put anything machine-specific (IDE paths, work tokens, private aliases) in `~/.zshrc.local` — it's sourced at the end of `.zshrc` and never committed.

## After fresh install

1. **Tmux plugins** — open tmux, press `prefix + I` (Ctrl-A I).
2. **GPG signing** — `gpg --gen-key`, then set `user.signingkey` and add `gpgsign = true` under `[commit]` in `git/.gitconfig`.

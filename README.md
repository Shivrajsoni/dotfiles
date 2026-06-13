# Dotfiles

```bash
git clone https://github.com/Shivrajsoni/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash bootstrap.sh
```

Detects macOS / Linux, installs packages, sets up dev tools (Node, Bun, Python, Rust, C++), symlinks configs. Existing configs are backed up to `~/dotfiles_backup_<timestamp>/`.

## Quick commands

```bash
make install    # full setup (brew + link + toolchain + macos defaults)
make link       # re-symlink configs only (safe to re-run)
make brew       # install/update brew packages
make update     # upgrade brew + tmux plugins
```

## Flags

```bash
bash bootstrap.sh --dry-run    # preview all actions, no changes
bash bootstrap.sh --link-only  # re-link configs only, skip packages
```

## Structure

```
├── home/
│   ├── .zshrc             # zsh config
│   ├── .bashrc            # bash config (Linux)
│   └── .tmux.conf         # multiplexer
├── config/
│   ├── starship/          # prompt (→ ~/.config/starship.toml)
│   ├── wezterm/           # terminal emulator
│   ├── fastfetch/         # system info on shell open
│   ├── aerospace/         # tiling WM (macOS only)
│   └── sketchybar/        # status bar (macOS only)
├── git/.gitconfig         # git settings
├── obsidian/              # vault settings (manual setup)
├── wallpapers/            # wezterm backgrounds (gitignored, add locally)
├── scripts/
│   ├── dev-toolchain.sh   # nvm, bun, uv, rust, c++
│   ├── macos-defaults.sh  # keyboard, finder, dock, security
│   └── linux-packages.sh  # apt / pacman / dnf
├── Brewfile               # macOS packages
├── Makefile               # shortcuts
└── bootstrap.sh           # entry point
```

## Machine-specific overrides

Put anything machine-specific (IDE paths, work tokens, private aliases) in `~/.zshrc.local` — it's sourced at the end of `.zshrc` and never committed.

## After fresh install

1. **Tmux plugins** — open tmux and press `prefix + I` (Ctrl-A I)
2. **GPG signing** — to enable signed commits:
   ```bash
   gpg --gen-key
   git config --global user.signingkey <YOUR_KEY_ID>
   # Then uncomment gpgsign = true in git/.gitconfig
   ```
3. **Wallpapers** — copy images into `~/dotfiles/wallpapers/` for wezterm backgrounds

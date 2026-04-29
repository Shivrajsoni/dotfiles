# Dotfiles

```bash
git clone https://github.com/Shivrajsoni/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash bootstrap.sh
```

Detects macOS / Linux, installs packages, sets up dev tools (Node, Bun, Python, Rust, C++), symlinks configs. Existing configs are backed up.

## Structure

```
├── bootstrap.sh           # setup entry point
├── Brewfile               # macOS packages
├── .zshrc                 # zsh config (macOS)
├── .bashrc                # bash config (Linux)
├── .tmux.conf             # multiplexer
├── starship.toml          # prompt
├── wezterm/               # terminal emulator
├── fastfetch/             # system info
├── git/                   # git config
├── aerospace/             # tiling WM (macOS)
├── sketchybar/            # status bar (macOS)
├── obsidian/              # vault settings
├── wallpapers/            # wezterm backgrounds (gitignored)
└── scripts/
    ├── dev-toolchain.sh   # nvm, bun, uv, rust, c++
    ├── macos-defaults.sh  # keyboard, finder, dock
    └── linux-packages.sh  # apt / pacman / dnf
```

Preview without changes: `bash bootstrap.sh --dry-run`

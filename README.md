# Terminal Nerd Dotfiles

A highly polished, minimalist, and deeply optimized terminal environment built primarily on Rust-based tooling. Designed for speed, aesthetics, and universal compatibility across macOS and Linux.

## The Arsenal

### Core Utilities
- **[Zsh](https://www.zsh.org/)**: The core interactive shell.
- **[Tmux](https://github.com/tmux/tmux)**: Terminal multiplexer for persistent sessions and pane management.
- **[WezTerm](https://wezfurlong.org/wezterm/)**: A GPU-accelerated cross-platform terminal emulator.

### Modern Replacements (Rust-based)
These tools replace legacy Unix utilities with blazing-fast modern equivalents:
- **[Starship](https://starship.rs/)**: The universally beautiful, infinitely customizable cross-shell prompt.
- **[Eza](https://github.com/eza-community/eza)**: A modern replacement for `ls` with rich colors, Git integration, and Nerd Font icons.
- **[Bat](https://github.com/sharkdp/bat)**: A `cat` clone with wings. Provides syntax highlighting and Git diffs natively.
- **[Yazi](https://github.com/sxyazi/yazi)**: A blazing-fast terminal file manager built for async I/O and native image previews.
- **[Zoxide](https://github.com/ajeetdsouza/zoxide)**: A smarter `cd` command that learns your habits for instant directory jumping.
- **[Fastfetch](https://github.com/fastfetch-cli/fastfetch)**: A highly performant, C-based system information tool styled with a minimalist Catppuccin aesthetic.

### macOS Ricing
- **[AeroSpace](https://github.com/nikitabobko/AeroSpace)**: An i3-like tiling window manager built specifically for macOS.
- **[SketchyBar](https://github.com/FelixKratz/SketchyBar)**: A highly customizable macOS status bar replacement.

---

## Duplicating This Environment

I have built a robust, minimalist installation script that relies on universal `curl` installers rather than fighting Linux package managers with PPA keys.

To spin up this exact environment on any remote server or local machine:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the installer:**
   ```bash
   bash install.sh
   ```

3. **Restart your shell:**
   ```bash
   exec zsh
   ```

> **Note**: The script will automatically safely backup any existing configurations to a timestamped `dotfiles_backup_` directory before establishing symlinks.

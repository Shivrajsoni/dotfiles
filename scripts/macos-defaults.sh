#!/usr/bin/env bash
# macOS Sensible Defaults for Developers
# Run once after a fresh macOS install, then log out / restart.

set -e

if [ "$(uname -s)" != "Darwin" ]; then
    echo "Not macOS — skipping."
    exit 0
fi

echo "Applying macOS developer defaults..."

# ── Keyboard ────────────────────────────────────────────────────────
# Fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Enable key repeat (disable press-and-hold for accented characters)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# ── Finder ──────────────────────────────────────────────────────────
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
# Show full POSIX path in title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# No warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# ── Dock ────────────────────────────────────────────────────────────
# Auto-hide dock
defaults write com.apple.dock autohide -bool true
# No delay on auto-hide
defaults write com.apple.dock autohide-delay -float 0
# Fast animation
defaults write com.apple.dock autohide-time-modifier -float 0.4
# Don't show recent apps
defaults write com.apple.dock show-recents -bool false
# Icon size
defaults write com.apple.dock tilesize -int 48

# ── Screenshots ─────────────────────────────────────────────────────
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"
# No shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# ── Trackpad ────────────────────────────────────────────────────────
# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# ── Misc ────────────────────────────────────────────────────────────
# TextEdit: plain text by default
defaults write com.apple.TextEdit RichText -int 0
# Disable "Are you sure you want to open this app?"
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "macOS defaults applied. Restart Finder and Dock..."
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
echo "Done. Some changes require a logout/restart."

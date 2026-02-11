#!/usr/bin/env sh

# —————————— Catppuccin Mocha Theme ——————————
# https://github.com/catppuccin/catppuccin

export BLACK=0xff181926
export WHITE=0xffcad3f5
export RED=0xffed8796
export GREEN=0xffa6da95
export BLUE=0xff8aadf4
export YELLOW=0xffeed49f
export ORANGE=0xfff5a97f
export MAGENTA=0xffc6a0f6
export CYAN=0xff89b4fa
export GRAY=0xff939ab7
export COMMENT=$GRAY
export TRANSPARENT=0x00000000

# General bar colors
export BAR_COLOR=0xcc1e1e2e # Bar color with transparency
export ICON_COLOR=$WHITE # Color of all icons
export LABEL_COLOR=$WHITE # Color of all labels
export SHADOW_COLOR=$BLACK

# Item-specific colors
export POPUP_BACKGROUND_COLOR=$BLACK
export POPUP_BORDER_COLOR=$BLUE

export SPOTIFY_GREEN=$GREEN

# —————————— Bar Style ——————————

# Bar
export BAR_HEIGHT=30
export BAR_CORNER_RADIUS=8
export BAR_Y_OFFSET=6 
export BAR_MARGIN=7
export BAR_BLUR=30

# Borders
export BORDER_WIDTH=1

# Shadows
export SHADOW=off

# Paddings
export PADDINGS=4

# Font
export FONT="JetBrainsMono Nerd Font"

# —————————— Directories ——————————

export ITEM_DIR="$SKETCHYBAR_CONFIG_DIR/items"
export PLUGIN_DIR="$SKETCHYBAR_CONFIG_DIR/plugins"

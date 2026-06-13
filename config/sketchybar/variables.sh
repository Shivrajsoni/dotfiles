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

export BASE=0xff1e1e2e
export SURFACE0=0xff313244
export SURFACE1=0xff45475a
export SURFACE2=0xff585b70
export OVERLAY0=0xff6c7086

# General bar colors
export BAR_COLOR=$TRANSPARENT
export ICON_COLOR=$WHITE # Color of all icons
export LABEL_COLOR=$WHITE # Color of all labels
export SHADOW_COLOR=$BLACK

# Item-specific colors
export POPUP_BACKGROUND_COLOR=$BLACK
export POPUP_BORDER_COLOR=$BLUE

export SPOTIFY_GREEN=$GREEN

# —————————— Bar Style ——————————

# Bar
export BAR_HEIGHT=40
export BAR_CORNER_RADIUS=0
export BAR_Y_OFFSET=4
export BAR_MARGIN=10
export BAR_BLUR=40

# Item specific
export ITEM_CORNER_RADIUS=12
export ITEM_HEIGHT=28

# Borders
export BORDER_WIDTH=1

# Shadows
export SHADOW=on

# Paddings
export PADDINGS=6

# Font
export FONT="JetBrainsMono Nerd Font"

# —————————— Directories ——————————

export ITEM_DIR="$SKETCHYBAR_CONFIG_DIR/items"
export PLUGIN_DIR="$SKETCHYBAR_CONFIG_DIR/plugins"

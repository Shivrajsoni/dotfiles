#!/usr/bin/env sh

# —————————— Catppuccin Macchiato ——————————
export WHITE=0xffcad3f5
export RED=0xffed8796
export GREEN=0xffa6da95
export BLUE=0xff8aadf4
export YELLOW=0xffeed49f
export TRANSPARENT=0x00000000

export BASE=0xff24273a
export SURFACE0=0xff363a4f
export SURFACE1=0xff494d64
export SUBTEXT=0xffb8c0e0

# Single highlight color used across the bar
export ACCENT=$BLUE

# —————————— Bar geometry ——————————
# AeroSpace's gaps.outer.top must be >= BAR_Y_OFFSET + BAR_HEIGHT + a few px,
# otherwise tiled windows slide under the bar.
export BAR_HEIGHT=32
export BAR_Y_OFFSET=6
export BAR_MARGIN=10
export ITEM_HEIGHT=24
export ITEM_CORNER_RADIUS=8
export BORDER_WIDTH=1
export PADDINGS=4

export FONT="JetBrainsMono Nerd Font"

# —————————— Paths ——————————
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
export ITEM_DIR="$SKETCHYBAR_CONFIG_DIR/items"
export PLUGIN_DIR="$SKETCHYBAR_CONFIG_DIR/plugins"

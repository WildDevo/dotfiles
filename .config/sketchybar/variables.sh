#!/bin/bash

# Non-colour globals shared by items and plugins.
#
# Colours live in colors.sh and must not be defined here -- this file used to
# carry a second (Tokyonight) palette that nothing sourced, which shadowed the
# real one whenever it was pulled in by accident.

export FONT="MesloLGS NF"

export PADDINGS=3

# Geometry. One radius for items, a slightly larger one for the brackets that
# wrap them, so a group reads as a single surface rather than a box-in-a-box.
export CORNER_RADIUS=9
export BRACKET_CORNER_RADIUS=11
export POPUP_CORNER_RADIUS=11

export ITEM_HEIGHT=30
export BRACKET_HEIGHT=30

export BORDER_WIDTH=2
export POPUP_BORDER_WIDTH=2

export SHADOW=on

export ITEM_DIR="$HOME/.config/sketchybar/items"
export PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

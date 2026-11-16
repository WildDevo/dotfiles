#!/bin/bash

# Visual grouping, sourced last because a bracket can only reference items that
# already exist.
#
# Members give up their individual background so the bracket reads as one
# rounded surface rather than a row of separate pills.

bracket_style=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  background.border_width=$BORDER_WIDTH
  background.corner_radius=$BRACKET_CORNER_RADIUS
  background.height=$BRACKET_HEIGHT
  background.drawing=on
)

group() {
  local name="$1"
  shift
  [ $# -gt 0 ] || return

  sketchybar --add bracket "$name" "$@" \
             --set "$name" "${bracket_style[@]}"

  local member
  for member in "$@"; do
    sketchybar --set "$member" background.drawing=off
  done
}

# Focused window: layout indicator + app name.
group session window_state front_app

# System tray. $STATUS_ITEMS is set per-bar -- the desktop bar has brew, the
# laptop bar does not, and a bracket naming a missing item is dropped.
group status $STATUS_ITEMS

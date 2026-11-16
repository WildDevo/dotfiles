#!/bin/bash

# Layout indicator for the focused window. Replaces the old yabai.sh window_state.
# Clicking toggles the window between floating and tiling.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

update() {
  # "<layout>|<is fullscreen>|<parent container layout>", e.g. "tiling|false|h_tiles"
  state="$(aerospace list-windows --focused \
             --format '%{window-layout}|%{window-is-fullscreen}|%{window-parent-container-layout}' 2>/dev/null)"

  # No focused window (empty workspace) -- leave the last icon rather than blank out.
  [ -z "$state" ] && exit 0

  layout="${state%%|*}"
  rest="${state#*|}"
  fullscreen="${rest%%|*}"
  parent="${rest#*|}"

  if [ "$fullscreen" = "true" ]; then
    icon=$WM_FULLSCREEN
    color=$GREEN
  elif [ "$layout" = "floating" ]; then
    icon=$WM_FLOAT
    color=$MAGENTA
  elif [[ "$parent" == *accordion* ]]; then
    icon=$WM_ACCORDION
    color=$BLUE
  else
    icon=$WM_TILES
    color=$ORANGE
  fi

  sketchybar --set "$NAME" icon="$icon" icon.color="$color"
}

case "$SENDER" in
  "mouse.clicked")
    aerospace layout floating tiling
    update
    ;;
  "forced") exit 0
    ;;
  *) update
    ;;
esac

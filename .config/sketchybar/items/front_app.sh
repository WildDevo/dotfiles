#!/bin/bash

FRONT_APP_SCRIPT='sketchybar --set $NAME label="$INFO"'

window_state=(
  script="$PLUGIN_DIR/window_state.sh"
  icon.font="$FONT:Bold:16.0"
  label.drawing=off
  icon.width=30
  icon=$WM_TILES
  icon.color=$ORANGE
  associated_display=active
)

front_app=(
  script="$FRONT_APP_SCRIPT"
  icon.drawing=off
  padding_left=0
  label.color=$WHITE
  label.font="$FONT:Black:12.0"
  associated_display=active
)

sketchybar --add item window_state left                    \
           --set window_state "${window_state[@]}"         \
           --subscribe window_state aerospace_focus_change \
                                    aerospace_workspace_change \
                                    mouse.clicked          \
                                                           \
           --add item front_app left                       \
           --set front_app "${front_app[@]}"               \
           --subscribe front_app front_app_switched


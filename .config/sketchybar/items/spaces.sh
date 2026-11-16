#!/bin/bash

source "$CONFIG_DIR/workspaces.sh"

# AeroSpace workspaces are not macOS Spaces, so these are plain items rather
# than `--add space` items -- there is no macOS space id to associate them with.
# Left click focuses the workspace; plugins/aerospace.sh keeps them in sync.

sketchybar --add event aerospace_workspace_change \
           --add event aerospace_focus_change

# Every workspace gets an item up front -- creating and destroying items on each
# switch is far more expensive than toggling `drawing`. plugins/aerospace.sh
# decides which are actually shown: occupied ones, plus the focused one so you
# can always see where you are.
for wsid in $WORKSPACES; do
  space=(
    icon="$wsid"
    icon.padding_left=8
    icon.padding_right=6
    icon.color=$SUBTEXT0
    icon.highlight_color=$ACCENT_COLOR
    label.font="sketchybar-app-font:Regular:14.0"
    label.color=$SUBTEXT0
    label.padding_left=0
    label.padding_right=8
    label.drawing=off
    padding_left=2
    padding_right=2
    # The focused workspace gets this chip; the plugin turns it on.
    background.color=$SURFACE2
    background.corner_radius=$CORNER_RADIUS
    background.height=24
    background.drawing=off
    # Hidden until the plugin decides otherwise, so the row starts empty rather
    # than flashing all seven on load.
    drawing=off
    click_script="aerospace workspace $wsid"
  )

  sketchybar --add item space.$wsid left \
             --set space.$wsid "${space[@]}"
done

# A single hidden item drives every space item, so a workspace change costs one
# aerospace query instead of one per workspace. updates=on is required: the
# global default is updates=when_shown, which never runs the script of an item
# that isn't drawn.
# update_freq is a safety net, not the main path: the events below do the real
# work. It exists so the row recovers on its own if AeroSpace was down when
# sketchybar loaded, or if an event is ever missed.
sketchybar --add item spaces_driver left                        \
           --set spaces_driver drawing=off                      \
                               updates=on                       \
                               update_freq=30                   \
                               script="$PLUGIN_DIR/aerospace.sh" \
           --subscribe spaces_driver aerospace_workspace_change  \
                                     aerospace_focus_change

# One filled surface behind the whole workspace row, matching the session and
# status brackets in groups.sh.
spaces=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  background.border_width=$BORDER_WIDTH
  background.corner_radius=$BRACKET_CORNER_RADIUS
  background.height=$BRACKET_HEIGHT
  background.drawing=on
)

sketchybar --add bracket spaces '/space\..*/' \
           --set spaces "${spaces[@]}"

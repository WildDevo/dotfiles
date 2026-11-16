#!/bin/bash

# Keeps the workspace indicator in sync with AeroSpace.
#
# Driven by the hidden `spaces_driver` item, which subscribes to:
#   aerospace_workspace_change -- exec-on-workspace-change in aerospace.toml,
#                                 carries FOCUSED_WORKSPACE
#   aerospace_focus_change     -- on-focus-changed in aerospace.toml, catches
#                                 windows opening, closing and moving
#
# Only workspaces holding windows are drawn, plus the focused one so there is
# always a visible marker for where you are. Everything is applied in a single
# batched sketchybar call.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/workspaces.sh"
# Defines icon_map(), which sets $icon_result. Sourcing it also runs its own
# trailing `icon_map "$1"; echo`, hence the redirect.
source "$CONFIG_DIR/plugins/icon_map_fn.sh" > /dev/null

# One query for every window on every monitor, as "<workspace>|<app name>".
# A failure means the AeroSpace server is down, which makes the whole row
# meaningless -- hide it rather than leaving a stale or empty bracket behind.
# spaces_driver polls on a slow timer, so this recovers on its own once
# AeroSpace is back even if no event fires.
if ! WINDOWS="$(aerospace list-windows --all --format '%{workspace}|%{app-name}' 2>/dev/null)"; then
  sketchybar --set spaces drawing=off
  exit 0
fi

# aerospace_workspace_change carries the focused workspace; other senders don't.
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
if [ -z "$FOCUSED" ]; then
  sketchybar --set spaces drawing=off
  exit 0
fi

args=(--set spaces drawing=on)
for wsid in $WORKSPACES; do
  icon_strip=""
  while IFS='|' read -r ws app; do
    [ "$ws" = "$wsid" ] || continue
    icon_map "$app"
    icon_strip+=" $icon_result"
  done <<< "$WINDOWS"

  if [ "$wsid" = "$FOCUSED" ]; then
    args+=(--set space.$wsid drawing=on
                             background.drawing=on
                             icon.highlight=on
                             label.color=$TEXT)
  elif [ -n "$icon_strip" ]; then
    args+=(--set space.$wsid drawing=on
                             background.drawing=off
                             icon.highlight=off
                             label.color=$SUBTEXT0)
  else
    # Empty and unfocused: drop it from the row entirely.
    args+=(--set space.$wsid drawing=off)
    continue
  fi

  if [ -n "$icon_strip" ]; then
    args+=(label="$icon_strip" label.drawing=on)
  else
    # Focused but empty -- show the number on its own.
    args+=(label.drawing=off)
  fi
done

sketchybar --animate tanh 20 "${args[@]}"

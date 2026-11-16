#!/bin/bash

calendar=(
  icon=
  icon.font="$FONT:Black:12.0"
  icon.padding_right=0
  label.align=right
  update_freq=1
  script="$PLUGIN_DIR/calendar.sh"
  # Click opens Calendar. The previous click_script pointed at plugins/zen.sh,
  # which does not exist in this config.
  click_script="open -a Calendar"
)

sketchybar --add item calendar right       \
           --set calendar "${calendar[@]}" \
           --subscribe calendar system_woke

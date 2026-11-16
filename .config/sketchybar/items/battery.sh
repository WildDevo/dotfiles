#!/bin/bash

# $COLOR is set by plugins/battery.sh per charge level, so it has no value here
# -- the old label.color/border_color referencing it resolved to empty. The
# plugin sets icon.color on each update; the label just follows the theme.
sketchybar --add item battery right \
           --set battery \
           update_freq=60 \
           script="$PLUGIN_DIR/battery.sh" \
           icon.padding_left=10 \
           icon.padding_right=6 \
           label.color="$TEXT" \
           label.padding_right=10 \
           --subscribe battery system_woke power_source_change

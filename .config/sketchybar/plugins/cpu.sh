#!/bin/bash

# Total CPU load as a share of all logical cores. One ps and one awk: the old
# version split the same sum into user/system halves with a pipeline per half,
# then added them back together.
CORES=$(sysctl -n hw.logicalcpu)
CPU_PERCENT=$(ps -A -o %cpu= | awk -v cores="$CORES" '{ sum += $1 } END { printf "%.0f", sum / cores }')

sketchybar --set "$NAME" label="$CPU_PERCENT%"

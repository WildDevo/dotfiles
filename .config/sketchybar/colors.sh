#!/bin/bash

# Catppuccin Frappe -- matches nvim (catppuccin-frappe), tmux and kitty.
#
# Palette first, then anything derived from it. Order matters: this file is
# sourced top to bottom, so a derived colour defined above its palette entry
# silently evaluates to an empty string.

# -- Palette --
export ROSEWATER=0xfff2d5cf
export FLAMINGO=0xffeebebe
export PINK=0xfff4b8e4
export MAUVE=0xffca9ee6
export RED=0xffe78284
export MAROON=0xffea999c
export PEACH=0xffef9f76
export YELLOW=0xffe5c890
export GREEN=0xffa6d189
export TEAL=0xff81c8be
export SKY=0xff99d1db
export SAPPHIRE=0xff85c1dc
export BLUE=0xff8caaee
export LAVENDER=0xffbabbf1

export TEXT=0xffc6d0f5
export SUBTEXT1=0xffb5bfe2
export SUBTEXT0=0xffa5adce
export OVERLAY2=0xff949cbb
export OVERLAY1=0xff838ba7
export OVERLAY0=0xff737994
export SURFACE2=0xff626880
export SURFACE1=0xff51576d
export SURFACE0=0xff414559
export BASE=0xff303446
export MANTLE=0xff292c3c
export CRUST=0xff232634

export TRANSPARENT=0x00000000

# -- Aliases --
# The item and plugin scripts were written against these names; keeping them
# pointed at palette entries means a retheme only touches this file.
export WHITE=$TEXT
export BLACK=$CRUST
export GREY=$OVERLAY0
export MAGENTA=$MAUVE
export ORANGE=$PEACH
export CYAN=$SKY

# -- Semantic --
# The laptop bar floats, so it needs a real background rather than the
# desktop bar's transparent one.
export BAR_COLOR=0xe6303446   # base at ~90%
export ITEM_BG_COLOR=$SURFACE0
export ACCENT_COLOR=$BLUE

# Bracket fill and border. These were previously undefined, which left the
# volume/status bracket with no background at all.
export BACKGROUND_1=$SURFACE0
export BACKGROUND_2=$SURFACE1

export POPUP_BACKGROUND_COLOR=$MANTLE
export POPUP_BORDER_COLOR=$SURFACE2
export SHADOW_COLOR=$CRUST

#!/bin/bash

# GitHub notifications bell, driven by items/github.sh.
#
# A refresh is a single `gh api notifications` call. Each notification's link
# is derived from its API URL in jq (repos/o/r/pulls/N -> o/r/pull/N) rather
# than fetched, so it opens the issue/PR/commit itself, not its latest comment.

update() {
  source "$CONFIG_DIR/colors.sh"
  source "$CONFIG_DIR/icons.sh"

  # gh logged out or offline: say so instead of showing an unread bell with
  # an empty count.
  local notifications
  if ! notifications="$(gh api notifications 2>/dev/null)"; then
    sketchybar --set "$NAME" icon="$BELL" icon.color="$GREY" label="!"
    return
  fi

  local count prev_count
  count="$(jq 'length' <<< "$notifications")"
  prev_count="$(sketchybar --query github.bell | jq -r .label.value)"

  local args=(--remove '/github.notification\.*/')
  if [ "$count" -eq 0 ]; then
    args+=(--set "$NAME" icon="$BELL" label="0" icon.color="$BLUE")
  else
    args+=(--set "$NAME" icon="$BELL_DOT" label="$count" icon.color="$BLUE")
  fi

  local counter=0 repo type url title color icon
  while IFS=$'\t' read -r repo type url title; do
    counter=$((counter + 1))

    case "$type" in
      Issue)       color=$GREEN;   icon=$GIT_ISSUE ;;
      PullRequest) color=$MAGENTA; icon=$GIT_PULL_REQUEST ;;
      Commit)      color=$WHITE;   icon=$GIT_COMMIT ;;
      Discussion)  color=$WHITE;   icon=$GIT_DISCUSSION ;;
      # Releases, CI runs, etc. Previously these silently reused the icon and
      # link of whatever notification came before them.
      *)           color=$BLUE;    icon=$BELL ;;
    esac

    if grep -Eiq 'deprecat|break|broke' <<< "$title"; then
      color=$RED
      icon=􀁞
      args+=(--set github.bell icon.color="$RED")
    fi

    local notification=(
      label="$title"
      icon="$icon $repo:"
      icon.padding_left=0
      label.padding_right=0
      icon.color="$color"
      icon.background.color="$color"
      position=popup.github.bell
      drawing=on
      click_script="open '$url'; sketchybar --set github.bell popup.drawing=off"
    )
    args+=(--clone github.notification.$counter github.template
           --set github.notification.$counter "${notification[@]}")
  done < <(jq -r '
    .[] | [
      .repository.name,
      .subject.type,
      (if (.subject.type | IN("Issue", "PullRequest", "Commit")) and .subject.url
       then .subject.url
            | sub("^https://api\\.github\\.com/repos/"; "https://github.com/")
            | sub("/pulls/"; "/pull/")
            | sub("/commits/"; "/commit/")
       else "https://github.com/notifications" end),
      (.subject.title | gsub("\t"; " "))
    ] | @tsv' <<< "$notifications")

  if [ "$counter" -eq 0 ]; then
    args+=(--clone github.notification.1 github.template
           --set github.notification.1 icon="Note:" label="No new notifications"
                                       icon.color="$BLUE" drawing=on)
  fi

  sketchybar -m "${args[@]}" > /dev/null

  if [ "$count" -gt "$prev_count" ] 2>/dev/null || [ "$SENDER" = "forced" ]; then
    sketchybar --animate tanh 15 --set github.bell label.y_offset=5 label.y_offset=0
  fi
}

popup() {
  sketchybar --set "$NAME" popup.drawing="$1"
}

case "$SENDER" in
  "routine"|"forced") update ;;
  "mouse.entered") popup on ;;
  "mouse.exited"|"mouse.exited.global") popup off ;;
  "mouse.clicked") popup toggle ;;
esac

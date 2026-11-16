#!/bin/bash

# Spotify player, driven by items/spotify.sh.
#
# Track metadata reaches us two ways:
#   1. $INFO, from the com.spotify.client.PlaybackStateChanged distributed
#      notification. Free, but it only fires when something actually changes.
#   2. AppleScript, used whenever $INFO is empty -- on sketchybar launch,
#      --reload and --update. Without this the player stays hidden after a
#      reload until the next track change, even with Spotify playing.
#
# Note that AppleScript formats numbers in the user's locale, so `player
# position` comes back as "134,4459" under en_PT. Every number out of
# osascript goes through to_int() for that reason.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

COVER_DIR="${TMPDIR:-/tmp}/sketchybar-spotify"
mkdir -p "$COVER_DIR"

# "state|track id|name|artist|album|duration(ms)|position(s)|shuffling|repeating"
spotify_tell() {
  osascript 2>/dev/null \
    -e 'tell application "Spotify"' \
    -e '  if it is not running then return "stopped|||||0|0|false|false"' \
    -e '  try' \
    -e '    return (player state as string) & "|" & (id of current track) & "|" ¬' \
    -e '      & (name of current track) & "|" & (artist of current track) & "|" ¬' \
    -e '      & (album of current track) & "|" & (duration of current track as string) ¬' \
    -e '      & "|" & (player position as string) & "|" & (shuffling as string) ¬' \
    -e '      & "|" & (repeating as string)' \
    -e '  on error' \
    -e '    return "stopped|||||0|0|false|false"' \
    -e '  end try' \
    -e 'end tell'
}

# Locale-safe whole number: "134,4459" and "134.4459" both become 134.
to_int() {
  local n="${1//,/.}"
  n="${n%%.*}"
  [[ "$n" =~ ^-?[0-9]+$ ]] || n=0
  printf '%s' "$n"
}

fmt_time() {
  printf '%02d:%02d' $(( $1 / 60 )) $(( $1 % 60 ))
}

shorten() {
  sed 's/\(.\{'"$2"'\}\).*/\1.../' <<< "$1"
}

next() { osascript -e 'tell application "Spotify" to play next track' 2>/dev/null; }
back() { osascript -e 'tell application "Spotify" to play previous track' 2>/dev/null; }
play() { osascript -e 'tell application "Spotify" to playpause' 2>/dev/null; }

repeat() {
  if [ "$(osascript -e 'tell application "Spotify" to get repeating' 2>/dev/null)" = "false" ]; then
    sketchybar -m --set spotify.repeat icon.highlight=on
    osascript -e 'tell application "Spotify" to set repeating to true' 2>/dev/null
  else
    sketchybar -m --set spotify.repeat icon.highlight=off
    osascript -e 'tell application "Spotify" to set repeating to false' 2>/dev/null
  fi
}

shuffle() {
  if [ "$(osascript -e 'tell application "Spotify" to get shuffling' 2>/dev/null)" = "false" ]; then
    sketchybar -m --set spotify.shuffle icon.highlight=on
    osascript -e 'tell application "Spotify" to set shuffling to true' 2>/dev/null
  else
    sketchybar -m --set spotify.shuffle icon.highlight=off
    osascript -e 'tell application "Spotify" to set shuffling to false' 2>/dev/null
  fi
}

update() {
  local state track artist album track_id shuffling repeating

  if [ -n "$INFO" ]; then
    state="$(jq -r '.["Player State"] // empty' <<< "$INFO")"
    track="$(jq -r '.Name // empty' <<< "$INFO")"
    artist="$(jq -r '.Artist // empty' <<< "$INFO")"
    album="$(jq -r '.Album // empty' <<< "$INFO")"
    track_id="$(jq -r '.["Track ID"] // empty' <<< "$INFO")"
    # The notification carries no shuffle/repeat state, so ask for those.
    IFS='|' read -r shuffling repeating <<< "$(osascript 2>/dev/null \
      -e 'tell application "Spotify" to return (shuffling as string) & "|" & (repeating as string)')"
  else
    IFS='|' read -r state track_id track artist album _ _ shuffling repeating \
      <<< "$(spotify_tell)"
  fi

  # The notification capitalises ("Playing"); AppleScript does not ("playing").
  state="$(tr '[:upper:]' '[:lower:]' <<< "$state")"

  if [ "$state" != "playing" ]; then
    sketchybar -m --set spotify.anchor drawing=off popup.drawing=off \
                  --set spotify.play icon="$SPOTIFY_PLAY"
    return
  fi

  local title_label artist_label album_label
  title_label="$(shorten "$track" 20)"
  if [ -z "$artist" ]; then
    # Podcasts have no artist; Spotify puts the show name in the album field.
    artist_label="$(shorten "$album" 20)"
    album_label="Podcast"
  else
    artist_label="$(shorten "$artist" 20)"
    album_label="$(shorten "$album" 25)"
  fi

  # Artwork is cached per track, so re-selecting a track costs no download.
  local cover="$COVER_DIR/${track_id##*:}.jpg"
  if [ -n "$track_id" ] && [ ! -s "$cover" ]; then
    local url
    url="$(osascript -e 'tell application "Spotify" to return artwork url of current track' 2>/dev/null)"
    if [ -n "$url" ]; then
      curl -sf --max-time 10 "$url" -o "$cover"
      # Only worth walking the cache on the rare miss.
      find "$COVER_DIR" -name '*.jpg' -mtime +7 -delete 2>/dev/null
    fi
  fi

  local args=(
    --set spotify.title   label="$title_label"
    --set spotify.artist  label="$artist_label"
    --set spotify.album   label="$album_label"
    --set spotify.play    icon="$SPOTIFY_PAUSE"
    --set spotify.shuffle icon.highlight="$shuffling"
    --set spotify.repeat  icon.highlight="$repeating"
    --set spotify.anchor  drawing=on
  )
  [ -s "$cover" ] && args+=(--set spotify.cover background.image="$cover" \
                                                background.color="$TRANSPARENT")

  sketchybar -m "${args[@]}"
}

scrubbing() {
  local raw_duration duration target
  IFS='|' read -r _ _ _ _ _ raw_duration _ _ _ <<< "$(spotify_tell)"

  duration=$(( $(to_int "$raw_duration") / 1000 ))
  [ "$duration" -gt 0 ] || return

  target=$(( duration * PERCENTAGE / 100 ))
  osascript -e "tell application \"Spotify\" to set player position to $target" 2>/dev/null
  sketchybar --set spotify.state slider.percentage="$PERCENTAGE"
}

scroll() {
  local raw_duration raw_position duration elapsed
  IFS='|' read -r _ _ _ _ _ raw_duration raw_position _ _ <<< "$(spotify_tell)"

  duration=$(( $(to_int "$raw_duration") / 1000 ))   # reported in milliseconds
  elapsed=$(to_int "$raw_position")                  # reported in seconds

  # Nothing loaded, or Spotify closed -- leave the slider as it is rather than
  # dividing by zero.
  [ "$duration" -gt 0 ] || return

  sketchybar --animate linear 10 \
             --set spotify.state slider.percentage=$(( elapsed * 100 / duration )) \
                                 icon="$(fmt_time "$elapsed")" \
                                 label="$(fmt_time "$duration")"
}

mouse_clicked() {
  case "$NAME" in
    "spotify.next")    next ;;
    "spotify.back")    back ;;
    "spotify.play")    play ;;
    "spotify.shuffle") shuffle ;;
    "spotify.repeat")  repeat ;;
    "spotify.state")   scrubbing ;;
    *) exit ;;
  esac
}

popup() {
  sketchybar --set spotify.anchor popup.drawing="$1"
}

routine() {
  case "$NAME" in
    "spotify.state") scroll ;;
    *) update ;;
  esac
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked ;;
  "mouse.entered") popup on ;;
  "mouse.exited"|"mouse.exited.global") popup off ;;
  "routine") routine ;;
  *)
    # spotify_change and forced reach every item sharing this script. One full
    # refresh covers them all, so let the anchor own it rather than firing
    # eight concurrent AppleScript round-trips.
    [ "$NAME" = "spotify.anchor" ] && update
    ;;
esac

#!/usr/bin/env bash

CONFIG="$HOME/dotfiles/lazygit/config.yml"

if [[ ! -f "$CONFIG" ]]; then
  echo "❌ Config not found: $CONFIG"
  exit 1
fi

# Detect which theme is active
ACTIVE_MODE=$(awk '
  $0 ~ /^# *DARK THEME/  { in_dark = 1; in_light = 0; next }
  $0 ~ /^# *LIGHT THEME/ { in_light = 1; in_dark = 0; next }
  in_dark && $0 ~ /^[^#[:space:]]/ { print "dark"; exit }
  in_light && $0 ~ /^[^#[:space:]]/ { print "light"; exit }
' "$CONFIG")

if [[ -z "$ACTIVE_MODE" ]]; then
  echo "❌ Could not detect active theme block"
  exit 1
fi

if [[ "$ACTIVE_MODE" == "dark" ]]; then
  COMMENT_DARK=true
  COMMENT_LIGHT=false
  SWITCH_TO="light"
else
  COMMENT_DARK=false
  COMMENT_LIGHT=true
  SWITCH_TO="dark"
fi

TMP=$(mktemp)

awk -v cd="$COMMENT_DARK" -v cl="$COMMENT_LIGHT" '
  $0 ~ /^# *DARK THEME/ {
    in_dark=1; in_light=0
    print
    next
  }
  $0 ~ /^# *LIGHT THEME/ {
    in_dark=0; in_light=1
    print
    next
  }

  in_dark {
    if (cd && $0 ~ /^[^#]/)         { print "# " $0; next }
    if (!cd && $0 ~ /^# +[^#]/)     { sub(/^# +/, "", $0); print; next }
    print
    next
  }

  in_light {
    if (cl && $0 ~ /^[^#]/)         { print "# " $0; next }
    if (!cl && $0 ~ /^# +[^#]/)     { sub(/^# +/, "", $0); print; next }
    print
    next
  }

  { print }
' "$CONFIG" > "$TMP"

mv "$TMP" "$CONFIG"
echo "🌗 Switched from $ACTIVE_MODE → $SWITCH_TO theme"

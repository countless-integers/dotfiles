#!/usr/bin/env bash

CONFIG="$HOME/dotfiles/starship/starship.toml"

if [[ ! -f "$CONFIG" ]]; then
  echo "❌ Starship config not found: $CONFIG"
  exit 1
fi

TMP=$(mktemp)

awk '
  BEGIN { in_dark = 0; in_light = 0 }
  /^# *DARK THEME/  { in_dark = 1; in_light = 0; print; next }
  /^# *LIGHT THEME/ { in_dark = 0; in_light = 1; print; next }

  in_dark && /^palette *=/ {
    print "# " $0; next
  }
  in_dark && /^# *palette *=/ {
    sub(/^#\s*/, "", $0)
    print; next
  }

  in_light && /^palette *=/ {
    print "# " $0; next
  }
  in_light && /^# *palette *=/ {
    sub(/^#\s*/, "", $0)
    print; next
  }

  { print }
' "$CONFIG" > "$TMP"

mv "$TMP" "$CONFIG"

echo "🎨 Starship theme toggled based on comment headers."

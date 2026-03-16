#!/usr/bin/env bash

detect_theme() {
  case "$(uname -s)" in
    Darwin)
      defaults read -g AppleInterfaceStyle 2>/dev/null | grep -qi dark && echo dark || echo light
      ;;
    Linux)
      if command -v gsettings &>/dev/null; then
        scheme=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
        [[ "$scheme" == *"dark"* ]] && echo dark || echo light
      elif command -v kreadconfig5 &>/dev/null; then
        scheme=$(kreadconfig5 --file kdeglobals --group General --key ColorScheme 2>/dev/null)
        [[ "${scheme,,}" == *"dark"* ]] && echo dark || echo light
      else
        echo dark
      fi
      ;;
    *)
      echo dark
      ;;
  esac
}

if [[ -n "$1" ]]; then
  MODE="$1"
else
  MODE=$(detect_theme)
  echo "Auto-detected theme: $MODE"
fi

if [[ "$MODE" != "dark" && "$MODE" != "light" ]]; then
  echo "Usage: $0 [dark|light]"
  exit 1
fi

if [[ "$MODE" == "dark" ]]; then
  COMMENT_BLOCK="LIGHT THEME"
  UNCOMMENT_BLOCK="DARK THEME"
else
  COMMENT_BLOCK="DARK THEME"
  UNCOMMENT_BLOCK="LIGHT THEME"
fi

LG_CONFIG="$HOME/dotfiles/lazygit/config.yml"
STARSHIP_CONFIG="$HOME/dotfiles/starship/starship.toml"

toggle-comment-blocks.bash "$LG_CONFIG" "$COMMENT_BLOCK" "$UNCOMMENT_BLOCK"
toggle-comment-blocks.bash "$STARSHIP_CONFIG" "$COMMENT_BLOCK" "$UNCOMMENT_BLOCK"

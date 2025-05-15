#!/usr/bin/env bash

MODE=$1
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

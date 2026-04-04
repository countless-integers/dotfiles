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

ATUIN_CONFIG="$HOME/dotfiles/atuin/config.toml"
LG_CONFIG="$HOME/dotfiles/lazygit/config.yml"
STARSHIP_CONFIG="$HOME/dotfiles/starship/starship.toml"
TMUX_THEME_DIR="$HOME/dotfiles/tmux"

if command -v atuin &>/dev/null && [[ -f "$ATUIN_CONFIG" ]]; then
  ATUIN_THEME=$([[ "$MODE" == "dark" ]] && echo "catppuccin-macchiato" || echo "catppuccin-latte")
  sed -i'' -e "s/^name = \"catppuccin-.*\"/name = \"$ATUIN_THEME\"/" "$ATUIN_CONFIG"
  echo "✔ Atuin theme set to $ATUIN_THEME"
fi

echo "Working on $LG_CONFIG..."
toggle-comment-blocks.bash "$LG_CONFIG" "$COMMENT_BLOCK" "$UNCOMMENT_BLOCK"
echo "✔ $UNCOMMENT_BLOCK applied in $LG_CONFIG"

echo "Working on $STARSHIP_CONFIG..."
toggle-comment-blocks.bash "$STARSHIP_CONFIG" "$COMMENT_BLOCK" "$UNCOMMENT_BLOCK"
echo "✔ $UNCOMMENT_BLOCK applied in $STARSHIP_CONFIG"

echo "Working on $TMUX_THEME_DIR/theme.conf..."
ln -sf "$TMUX_THEME_DIR/theme-${MODE}.conf" "$TMUX_THEME_DIR/theme.conf"
if tmux info &>/dev/null; then
  CATPPUCCIN_FLAVOR=$([[ "$MODE" == "dark" ]] && echo "macchiato" || echo "latte")
  CATPPUCCIN_PLUGIN=~/.tmux/plugins/tmux
  # Unset all cached catppuccin and theme options so everything re-applies cleanly
  tmux show-options -g | awk '/^@thm_|^@catppuccin_/{print $1}' | xargs -I{} tmux set -gu {}
  tmux set -g @catppuccin_flavor "$CATPPUCCIN_FLAVOR"
  tmux source "$HOME/dotfiles/tmux/catppuccin-options.conf"
  tmux source "$CATPPUCCIN_PLUGIN/catppuccin_options_tmux.conf"
  tmux source "$CATPPUCCIN_PLUGIN/catppuccin_tmux.conf"
fi
echo "✔ ${UNCOMMENT_BLOCK} applied in $TMUX_THEME_DIR/theme.conf"

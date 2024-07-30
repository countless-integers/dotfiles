local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- Appearance
config.color_scheme = 'Catppuccin Macchiato'
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font "JetBrainsMono Nerd Font Mono"
config.font_size = 16
config.line_height = 1.2

config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10

return config

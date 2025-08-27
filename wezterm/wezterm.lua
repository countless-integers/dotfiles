local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- Appearance

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Macchiato'
  end
  -- return 'Catppuccin Latte'
  -- return 'Gruvbox Light'
  return 'rose-pine-dawn'
end

config.color_scheme = scheme_for_appearance(get_appearance())
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font_with_fallback {
  "JetBrainsMono Nerd Font Mono",
  "JetBrains Mono",
}
config.font_size = 16
config.line_height = 1.3
config.warn_about_missing_glyphs = false

config.command_palette_font_size = config.font_size

config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10

config.window_close_confirmation = 'NeverPrompt'
config.skip_close_confirmation_for_processes_named = {
  'bash',
  'zsh',
  'tmux',
  'nu',
}

return config

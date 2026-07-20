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
  -- return 'rose-pine-dawn'
  return 'dayfox'
end

config.color_scheme = scheme_for_appearance(get_appearance())
config.font = wezterm.font_with_fallback {
  "FiraCode Nerd Font",
  "JetBrainsMono Nerd Font Mono",
  "JetBrains Mono",
}
-- macOS
local font_size = 16
if wezterm.target_triple:find 'linux' then
  font_size = 13
end
config.font_size = font_size
config.line_height = 1.3
config.warn_about_missing_glyphs = false
config.adjust_window_size_when_changing_font_size = false

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

-- Supposedly helps with passthrough for "exotic" key combos like shift-enter...
config.enable_kitty_keyboard = true

config.keys = {
  {
    key = 'f',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.QuickSelect,
  },
}

return config

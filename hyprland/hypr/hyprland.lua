-- Minimal Hyprland config in the Lua syntax (Hyprland 0.55+).
-- API reference: https://wiki.hypr.land/Configuring/Start/
-- Palette: Catppuccin Mocha — https://github.com/catppuccin/catppuccin

-- Monitors — https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- Programs
local terminal = "wezterm"
local browser  = "firefox"
local launcher = "hyprlauncher"

-- Environment — https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("MOZ_ENABLE_WAYLAND", "1") -- Firefox on native Wayland

-- Autostart — https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("mako")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

-- Look & feel — https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border   = { colors = { "rgba(cba6f7ee)", "rgba(89b4faee)" }, angle = 45 }, -- mauve -> blue
            inactive_border = "rgba(45475aaa)",                                                -- surface1
        },
        resize_on_border = true,
        layout = "dwindle",
    },
    decoration = {
        rounding = 8,
        active_opacity   = 1.0,
        inactive_opacity = 0.95,
        blur   = { enabled = true, size = 4, passes = 2 },
        shadow = { enabled = false },
    },
    animations = { enabled = true },
    dwindle    = { preserve_split = true },
    input = {
        kb_layout    = "us",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad     = { natural_scroll = true },
    },
    misc = {
        disable_hyprland_logo   = true,
        force_default_wallpaper = 0,
    },
})

-- Keybinds — https://wiki.hypr.land/Configuring/Basics/Binds/
local mod = "SUPER"

-- launch
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + R",      hl.dsp.exec_cmd(launcher))

-- window management
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F",      hl.dsp.window.fullscreen())
hl.bind(mod .. " + T",      hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exit())

-- focus (vim keys)
hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))

-- move window (vim keys)
hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))

-- workspaces: SUPER+[0-9] focus, SUPER+SHIFT+[0-9] move active window
for i = 1, 10 do
    local key = i % 10 -- 10 -> key 0
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- scratchpad
hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- mouse drag / resize
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- screenshots (needs grim, slurp, wl-clipboard)
hl.bind("Print",         hl.dsp.exec_cmd("grim - | wl-copy"))
hl.bind(mod .. " + Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

-- media & brightness keys (needs wireplumber, brightnessctl)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

# Hyprland desktop (Arch)

Minimal Hyprland setup in the **Lua** config syntax introduced in Hyprland 0.55
(hyprlang is deprecated and dropped ~1-2 releases later). Requires Hyprland >= 0.55.

Source for the Lua API: https://wiki.hypr.land/Configuring/Start/
Announcement: https://hypr.land/news/26_lua/

## Packages

All are in the official `extra` repo (verified via https://archlinux.org/packages), so
one pacman line does it — no AUR helper needed:

    sudo pacman -S --needed hyprland waybar wezterm firefox \
      hyprpaper hyprlock hypridle hyprpolkitagent hyprlauncher mako \
      wireplumber brightnessctl grim slurp wl-clipboard ttf-jetbrains-mono-nerd \
      wofi jq

`wofi` + `jq` are for the `SUPER + /` keybind cheatsheet (see below).

## Layout

- `hypr/hyprland.lua`   — compositor config (linked to `~/.config/hypr/`)
- `hypr/hyprpaper.conf` — wallpaper daemon (hyprlang; add your own image)
- `hypr/hyprlock.conf`  — lock screen (hyprlang)
- `hypr/hypridle.conf`  — idle: lock @5min, screen off @5.5min, suspend @15min (hyprlang)
- `waybar/config.jsonc` — status bar · `waybar/style.css` — Catppuccin Mocha
- `mako/config`         — notifications, Catppuccin Mocha (linked to `~/.config/mako/`)

Only `hyprland.lua` uses the new Lua syntax. hyprpaper/hyprlock/hypridle are separate
ecosystem tools and still use hyprlang; mako uses its own INI format.

dotbot links these on Linux only (gated on `hyprctl` / `waybar` / `mako` in `install.conf.yaml`).

## Keybinds (SUPER)

- `Return` term (wezterm) · `B` browser (firefox) · `R` launcher · `Q` close · `SHIFT+Q` exit
- `V` float · `F` fullscreen · `T` toggle split · `Escape` lock (hyprlock)
- `h/j/k/l` focus · `SHIFT+h/j/k/l` move window · `1-0` workspaces (+`SHIFT` move)
- `S` scratchpad · `Print` screenshot · `SUPER+Print` region screenshot
- `/` keybind cheatsheet (hypr-binds via wofi)

## Keybind cheatsheet

`SUPER + /` runs `~/bin/hypr-binds-wofi.sh` (hypr-binds), which lists every bind in a
wofi menu. The script is fetched by dotbot's shell step; the readable label comes from
each bind's `description`. Note: because binds use the Lua config, `hyprctl binds`
reports their dispatcher as `__lua`, so the trailing dispatcher column is noise and
"select to run" is a no-op — it's a viewer, not a launcher.

Upstream: https://github.com/hyprland-community/hypr-binds

## Not included

- a wallpaper image for hyprpaper (add one, then uncomment the lines in `hyprpaper.conf`)

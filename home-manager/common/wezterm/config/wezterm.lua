local wezterm = require 'wezterm'
local act = wezterm.action

config = wezterm.config_builder()

config.enable_wayland = true

config.color_scheme = 'AdventureTime'
config.window_background_opacity = 0.75

config.font_size = 17.0
config.font = wezterm.font("JetBrains Mono")
config.hide_tab_bar_if_only_one_tab = true

config.disable_default_key_bindings = true

config.default_prog = { 'fish', '-l' }

config.keys = {
    { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'C', mods = 'CTRL', action = act.CopyTo 'ClipboardAndPrimarySelection' },
}

return config

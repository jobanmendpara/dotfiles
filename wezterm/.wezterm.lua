local wezterm = require("wezterm")
local action = wezterm.action
local format = wezterm.format
local mux = wezterm.mux
local utils = require("lua.utils")
local unix_domains = require("lua.unix-domains")
local myKeymaps = require("lua.keymaps").setup(action, format, mux)
local event_handlers = require("lua.event_handlers").setup(wezterm, utils)

local config = wezterm.config_builder()

config.color_scheme = utils.matchSystemAppearance(wezterm.gui.get_appearance())
config.default_gui_startup_args = {"connect", "mbp-d1", "--workspace", "main"}
config.font = wezterm.font_with_fallback({
  "FiraCode Nerd Font",
  "FiraCode Nerd Font Mono",
  "Hack Nerd Font",
  "Hack Nerd Font Mono",
  "Iosevka Nerd Font",
  "Iosevka Nerd Font Mono",
  "JetBrainsMono Nerd Font",
  "JetBrainsMono Nerd Font Mono",
  "SauceCodePro Nerd Font",
  "SauceCodePro Nerd Font Mono",
  "SpaceMono Nerd Font",
  "SpaceMono Nerd Font Mono",
  "UbuntuMono Nerd Font",
  "UbuntuMono Nerd Font Mono",
})
config.font_size = 22
config.freetype_load_target = "HorizontalLcd"
config.keys = myKeymaps.keys
config.leader = myKeymaps.leader

config.pane_focus_follows_mouse = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.unix_domains = unix_domains

return config

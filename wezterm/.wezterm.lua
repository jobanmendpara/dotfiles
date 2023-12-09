wezterm = require("wezterm")
action = wezterm.action
action_callback = wezterm.action_callback
format = wezterm.format
log_info = wezterm.log_info
mux = wezterm.mux

utils = require("lua.utils")

local unix_domains = require("lua.unix-domains")
local myKeymaps = require("lua.keymaps").setup()
-- local event_handlers = require("lua.event_handlers").setup()

local config = wezterm.config_builder()
config.use_ime = false
config.check_for_updates = true

-- VISUALS
config.color_scheme = utils.matchSystemAppearance(wezterm.gui.get_appearance())
config.default_gui_startup_args = { "connect", "mbp", "--workspace", "main" }
config.font = wezterm.font_with_fallback({
  "Geist Mono",
  "Monaspace Argon",
  "Monaspace Xenon",
  "Monaspace Radon",
  "Monaspace Krypton",
  "Monaspace Neon",
  "JetBrainsMono Nerd Font",
  "SauceCodePro Nerd Font",
  "UbuntuMono Nerd Font",
  "FuraMono Nerd Font",
  "FiraCode Nerd Font",
  "Hack Nerd Font",
  "SpaceMono Nerd Font",
  "IosevkaTerm Nerd Font",
})

config.font_size = 19

config.use_fancy_tab_bar = false
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.native_macos_fullscreen_mode = false

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- BEHAVIOR
config.keys = myKeymaps.keys
config.leader = myKeymaps.leader
config.pane_focus_follows_mouse = true

config.unix_domains = unix_domains

return config

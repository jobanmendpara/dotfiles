wezterm = require("wezterm")
action = wezterm.action
action_callback = wezterm.action_callback
format = wezterm.format
log_info = wezterm.log_info
mux = wezterm.mux

utils = require("lua.utils")

local unix_domains = require("lua.unix-domains")
local myKeymaps = require("lua.keymaps").setup()
local event_handlers = require("lua.event_handlers").setup()

local config = wezterm.config_builder()
config.use_ime = false
config.check_for_updates = true
config.enable_kitty_keyboard = true
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- VISUALS
config.color_scheme = utils.matchSystemAppearance(wezterm.gui.get_appearance())
config.default_gui_startup_args = { "connect", "mbp", "--workspace", "main" }
config.font = wezterm.font_with_fallback({
  "Geist Mono",
  "SpaceMono Nerd Font",
  "Monaspace Radon",
  "Monaspace Krypton",
  "Monaspace Neon",
  "UbuntuMono Nerd Font",
  "SauceCodePro Nerd Font",
  "JetBrainsMono Nerd Font",
  "FuraMono Nerd Font",
  "FiraCode Nerd Font",
  "Hack Nerd Font",
  "Monaspace Argon",
  "IosevkaTerm Nerd Font",
  "Monaspace Xenon",
})

config.font_size = 19
config.freetype_load_target = 'HorizontalLcd'

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

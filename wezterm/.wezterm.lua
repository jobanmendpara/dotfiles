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

local config = wezterm.config_builder();
config.use_ime = false
 
-- VISUALS
config.color_scheme = utils.matchSystemAppearance(wezterm.gui.get_appearance())
config.default_gui_startup_args = {"connect", "mbp-d1", "--workspace", "main"}
config.font = wezterm.font_with_fallback({
  "Iosevka Nerd Font",
})
config.font_size = 23;
config.freetype_load_target = "HorizontalLcd";

config.hide_tab_bar_if_only_one_tab = true;

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

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
--

function matchSystemAppearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

-- For example, changing the color scheme:
config.color_scheme = matchSystemAppearance(wezterm.gui.get_appearance())
config.font = wezterm.font_with_fallback({
  "FiraCode Nerd Font",
  "FiraCode Nerd Font Mono",
})
config.font_size = 23

-- and finally, return the configuration to wezterm
return config
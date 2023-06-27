local favorites = require("lua.menus.favorites")

local M = {
	setup = function()
		local keymaps = {
			keys = {
				-- General
				{
					key = "Space",
					mods = "LEADER",
					action = action.ShowLauncher,
				},
				{
					key = "w",
					mods = "LEADER",
					action = action.ShowLauncherArgs({ flags = "WORKSPACES" }),
				},
        {
					key = "D",
					mods = "LEADER",
					action = action.ShowLauncherArgs({ flags = "DOMAINS" }),
				},
				{
					key = "c",
					mods = "LEADER",
					action = action.ShowLauncherArgs({ flags = "FUZZY|COMMANDS" }),
				},
				{
					key = "p",
					mods = "LEADER",
					action = action.ActivateCommandPalette,
				},
				{
					key = "q",
					mods = "LEADER",
					action = action.InputSelector({
						action = action_callback(function(window, pane, id, label)
							local cases = favorites(window, pane, id, label)

							local cmd = cases
							if cmd then
								cmd[id]()
							end
						end),
						title = "Quick Actions",
						choices = {
							{
								label = "Rename Tab",
								id = "RenameTab",
							},
						},
					}),
				},
				-- Tab Mappings
        {
          key = "{",
          mods = "LEADER|SHIFT",
          action = action.MoveTabRelative(-1)
        },
        {
          key = "}",
          mods = "LEADER|SHIFT",
          action = action.MoveTabRelative(1)
        },
				-- Pane Mappings
				{
					key = "|",
					mods = "LEADER|SHIFT",
					action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
				},
				{
					key = "_",
					mods = "LEADER|SHIFT",
					action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
				},
				{
					key = "d",
					mods = "LEADER",
					action = action.CloseCurrentPane({ confirm = true }),
				},
				{
					key = "h",
					mods = "LEADER",
					action = action.ActivatePaneDirection("Left"),
				},
				{
					key = "l",
					mods = "LEADER",
					action = action.ActivatePaneDirection("Right"),
				},
				{
					key = "k",
					mods = "LEADER",
					action = action.ActivatePaneDirection("Up"),
				},
				{
					key = "j",
					mods = "LEADER",
					action = action.ActivatePaneDirection("Down"),
				},
			},
			leader = {
				key = "Space",
				mods = "CTRL",
				timeout_milliseconds = 1000,
			},
		}

		return keymaps
	end,
}

return M

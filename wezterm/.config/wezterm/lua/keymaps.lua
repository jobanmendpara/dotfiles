local M = {
	setup = function(action, format, mux)
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
					action = action.ShowLauncherArgs({ flags = "WORKSPACES"}),
				},
				{
					key = "c",
					mods = "LEADER",
					action = action.ShowLauncherArgs({ flags = "FUZZY|COMMANDS"}),
				},
        -- Window / Pane Mappings
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
				mods = "ALT",
				timeout_milliseconds = 1000,
			},
		}

		return keymaps
	end,
}

return M

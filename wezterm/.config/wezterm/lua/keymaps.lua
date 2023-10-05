local renameMenu = require("lua.menus.renameMenu")

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
					key = "r",
					mods = "LEADER",
					action = action.InputSelector({
						action = action_callback(function(window, pane, id, label)
							local cases = renameMenu(window, pane, id, label)

							local cmd = cases
							if cmd then
								cmd[id]()
							end
						end),
						title = "Rename",
						choices = {
							{
								label = "Rename Tab",
								id = "RenameTab",
							},
							{
								label = "Rename Workspace",
								id = "RenameWorkspace",
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
					key = "LeftArrow",
					mods = "LEADER",
					action = action.ActivatePaneDirection("Left"),
				},
				{
					key = "RightArrow",
					mods = "LEADER",
					action = action.ActivatePaneDirection("Right"),
				},
				{
					key = "UpArrow",
					mods = "LEADER",
					action = action.ActivatePaneDirection("Up"),
				},
				{
					key = "DownArrow",
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

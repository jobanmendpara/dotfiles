local M = function(window, pane, id, label)
	local tab = window:active_tab()

	return {
		["RenameTab"] = function()
			window:perform_action(
				action.PromptInputLine({
					description = label,
					action = action_callback(function(window, pane, name)
						tab:set_title(name)
					end),
				}),
				pane
			)
		end,
	}
end

return M

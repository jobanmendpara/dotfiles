local M = {
  setup = function()
    wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
      local workspace_title = wezterm.mux.get_active_workspace()
      local tab_count = utils.length(tabs)
      local tab_index = tab.tab_index + 1

      local formatted_title = string.format("[ %d / %d ] - %s", tab_index, tab_count, workspace_title)

      return formatted_title
    end)

    return true
  end,
}

return M

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
          key = "LeftArrow",
          mods = "CMD|CTRL",
          action = action.MoveTabRelative(-1)
        },
        {
          key = "RightArrow",
          mods = "CMD|CTRL",
          action = action.MoveTabRelative(1)
        },
        -- Pane Mappings
        {
          key = "|",
          mods = "CMD|SHIFT",
          action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
        },
        {
          key = "_",
          mods = "CMD|SHIFT",
          action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
        },
        {
          key = "LeftArrow",
          mods = "CMD",
          action = action.ActivatePaneDirection("Left"),
        },
        {
          key = "RightArrow",
          mods = "CMD",
          action = action.ActivatePaneDirection("Right"),
        },
        {
          key = "UpArrow",
          mods = "CMD",
          action = action.ActivatePaneDirection("Up"),
        },
        {
          key = "DownArrow",
          mods = "CMD",
          action = action.ActivatePaneDirection("Down"),
        },
      },
      leader = {
        key = ".",
        mods = "CMD",
        timeout_milliseconds = 1000,
      },
    }

    return keymaps
  end,
}

return M

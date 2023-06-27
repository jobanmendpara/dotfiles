local M = {
  length = function (table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
  end,
  matchSystemAppearance = function (appearance)
    if appearance:find("Light") then
      return "Catppuccin Latte"
    else
      return "Catppuccin Mocha"
    end
  end,
}

return M

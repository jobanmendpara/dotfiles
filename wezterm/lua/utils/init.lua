local M = {}

M.matchSystemAppearance = function (appearance)
  if appearance:find("Dark") then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

return M

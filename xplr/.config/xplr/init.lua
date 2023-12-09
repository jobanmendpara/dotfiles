version = "0.21.3"
local home = os.getenv("HOME")
package.path = home
    .. "/.config/xplr/plugins/?/init.lua;"
    .. home
    .. "/.config/xplr/plugins/?.lua;"
    .. package.path

xplr.config.general.show_hidden = true

require("icons").setup()
require("tri-pane").setup()
require("trash-cli").setup {

  -- Trash file(s)
  trash_bin = "trash-put",
  trash_mode = "delete",
  trash_key = "d",

  -- Empty trash
  empty_bin = "trash-empty",
  empty_mode = "delete",
  empty_key = "E",

  -- Interactive selector
  trash_list_bin = "trash-list",
  trash_list_selector = "fzf -m | cut -d' ' -f3-",

  -- Restore file(s)
  restore_bin = "trash-restore",

  -- Restore files deleted from $PWD only
  restore_mode = "delete",
  restore_key = "r",

  -- Restore files deleted globally
  global_restore_mode = "delete",
  global_restore_key = "R",
}
require("zoxide").setup{
  bin = "zoxide",
  mode = "default",
  key = "z",
}

-- Type `Z` to spawn zoxide prompt.


-- Type `dd` to trash, `dr` or `dR` to restore, and `dE` to empty trash.
-- require("zentable").setup()

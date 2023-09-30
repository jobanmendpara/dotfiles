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
require("trash-cli").setup()
-- require("zentable").setup()

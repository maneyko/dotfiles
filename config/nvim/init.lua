local utils = require("config.utils")
require("config.autocmd")
require("config.options")
require("config.keymaps")
require("config.lsp")

utils.init_plugins()

vim.cmd.colorscheme("catppuccin-nvim")
-- vim.cmd.syntax("on")
vim.cmd("filetype plugin indent on")

-- utils.stop_lsps({fargs = {}, bang = true})
-- vim.treesitter.stop()

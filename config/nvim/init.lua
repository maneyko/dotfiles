require("vim._core.ui2").enable()

require("config.autocmd")
require("config.options")
require("config.keymaps")

require("plugins.treesitter")
require("config.treesitter")
-- require("config.treesitter-diagnostic")
require("plugins.core")
require("plugins.colors")

require("plugins.completion") -- breaks function..end
require("plugins.lsp")
require("config.lsp")

require("plugins.file-tree")
require("plugins.fzf")
require("plugins.mini")
require("plugins.syntax")

vim.cmd.colorscheme("catppuccin-nvim")
vim.cmd.syntax("on")
vim.cmd("filetype plugin indent on")

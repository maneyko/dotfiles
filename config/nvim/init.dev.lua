vim.g.mapleader = ","

vim.cmd("filetype off")

-- vim.o.foo = "\n"
-- TODO: foo

vim.o.autoindent = true
vim.o.breakindent = true
vim.o.clipboard = "unnamed"
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.ambiwidth = "double"
vim.o.expandtab = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.linebreak = true
vim.o.list = true
vim.opt.listchars = { tab = ">-", trail = "⋅" }
vim.o.errorbells = false
vim.o.visualbell = true
vim.o.belloff = "all"
vim.o.wildmenu = false
vim.o.number = true
vim.o.numberwidth = 3
vim.o.ruler = true
vim.o.scrolloff = 1
vim.o.shiftwidth = 4
vim.o.showcmd = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.softtabstop = 4
-- vim.o.t_Co = 256
vim.o.tabstop = 4
vim.o.tildeop = true
vim.o.wrap = false

-- if has("mouse")
if vim.fn.has("mouse") then
  vim.o.mouse = "a"
end
-- endif

vim.o.guicursor = ""
vim.o.laststatus = 0

vim.o.termguicolors = false

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.o.list = true
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.o.list = false
  end,
})

-- au InsertLeave * set list
-- au InsertEnter * set nolist
-- foo

vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })
vim.keymap.set("i", "jk", "<esc>", { desc = "Exit insert mode" })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<leader><leader>", "<cmd>w<cr>")
vim.keymap.set("n", "<C-b>", "<cmd>nohl<cr><C-l>")
vim.keymap.set("n", "<leader>kq", "<cmd>q!<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("i", "<C-a>", "<C-o>^")
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("n", "<leader>r", "<cmd>restart<cr>")

vim.keymap.set({"n", "i", "v"}, "<ScrollWheelUp>",     "<C-y>")
vim.keymap.set({"n", "i", "v"}, "<2-ScrollWheelUp>",   "<C-y>")
vim.keymap.set({"n", "i", "v"}, "<3-ScrollWheelUp>",   "<C-y>")
vim.keymap.set({"n", "i", "v"}, "<4-ScrollWheelUp>",   "<C-y>")
vim.keymap.set({"n", "i", "v"}, "<ScrollWheelDown>",   "<C-e>")
vim.keymap.set({"n", "i", "v"}, "<2-ScrollWheelDown>", "<C-e>")
vim.keymap.set({"n", "i", "v"}, "<3-ScrollWheelDown>", "<C-e>")
vim.keymap.set({"n", "i", "v"}, "<4-ScrollWheelDown>", "<C-e>")


require("config.lazy")

-- vim.cmd("colorscheme tokyonight-moon")
vim.cmd.colorscheme("catppuccin-nvim")
vim.cmd.syntax("on")
vim.cmd("filetype plugin indent on")
vim.cmd("highlight Normal ctermbg=NONE")
vim.cmd("highlight Normal ctermfg=NONE")

vim.g.mapleader = ","

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
vim.o.showcmd = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.tildeop = true
vim.o.wrap = false
vim.opt.mousescroll = "ver:1,hor:1"
vim.opt.spelllang = "en_us"

-- if vim.fn.has("mouse") == 1 then
  -- Try in all editors
  vim.o.mouse = "a"
-- end

vim.o.guicursor = ""
vim.o.laststatus = 0

vim.o.termguicolors = false

-- Disable diagnostic sidebar warnings
vim.diagnostic.config({signs = false})

vim.opt.updatetime = 3000 -- Reduce CursorHold delay to 3s

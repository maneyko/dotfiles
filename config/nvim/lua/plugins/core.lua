vim.pack.add({
  { src = "https://github.com/tpope/vim-repeat" },
  { src = "https://github.com/tpope/vim-endwise" },
  { src = "https://github.com/tpope/vim-rails" },
  { src = "https://github.com/Vimjas/vim-python-pep8-indent" },
  { src = "https://github.com/ZhiyuanLck/smart-pairs" },
})

require("pairs"):setup({
  enable_smart_space = true,
})

vim.pack.add({
  "https://github.com/tpope/vim-repeat",
  "https://github.com/tpope/vim-endwise",
  "https://github.com/rrethy/nvim-treesitter-endwise",
  "https://github.com/tpope/vim-rails",
  "https://github.com/Vimjas/vim-python-pep8-indent",
  "https://github.com/altermo/ultimate-autopair.nvim",
})


vim.pack.add({
  { src = "https://github.com/maneyko/nvim-treesitter-rails" },
})

vim.pack.add({ "https://github.com/andymass/vim-matchup" })
-- vim.g.matchup_treesitter_enable_quotes = false
require("match-up").setup({
  sync = true,  -- Run synchronously
  treesitter = {
    disable_virtual_text = true,
    enable_quotes = false,
  }
})
vim.api.nvim_set_hl(0, "MatchWord", { fg = "NONE", bg = "NONE" }) -- Do not highlight blocks

vim.pack.add({ "https://github.com/tpope/vim-markdown" })
vim.g.markdown_fenced_languages = { "bash=sh", "jq", "html", "python", "ruby", "sql", "yaml", "perl", "diff", "groovy", "lua", "javascript" }
vim.g.markdown_syntax_conceal = 0

vim.pack.add({ "https://github.com/junegunn/vim-easy-align" })
vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { remap = false })
vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { remap = false }) -- Visual-only mode, not select mode

require("ultimate-autopair").setup({
  pair_cmap = false,  -- Don't pair in command mode
  config_internal_pairs={},
   internal_pairs={
     -- Add completion for pipes in Ruby
     {'|','|',suround=true,ft={"ruby"},multiline=false},
     {'[',']',fly=true,dosuround=true,newline=true,space=true},
     {'(',')',fly=true,dosuround=true,newline=true,space=true},
     {'{','}',fly=true,dosuround=true,newline=true,space=true},
     {'"','"',suround=true,multiline=false},
     {"'","'",suround=true,cond=function(fn) return not fn.in_lisp() or fn.in_string() end,alpha=true,nft={'tex'},multiline=false},
     {'`','`',cond=function(fn) return not fn.in_lisp() or fn.in_string() end,nft={'tex'},multiline=false},
     {'``',"''",ft={'tex'}},
     {'```','```',newline=true,ft={'markdown'}},
     {'<!--','-->',ft={'markdown','html'},space=true},
     {'"""','"""',newline=true,ft={'python'}},
     {"'''","'''",newline=true,ft={'python'}},
   }
})

-- vim.pack.add({ "https://github.com/ZhiyuanLck/smart-pairs" })
-- require("pairs"):setup({
--   enable_smart_space = true,
-- })

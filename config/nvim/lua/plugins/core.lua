vim.pack.add({
  "https://github.com/tpope/vim-repeat",
  -- "https://github.com/tpope/vim-endwise",
  "https://github.com/rrethy/nvim-treesitter-endwise",
  "https://github.com/tpope/vim-rails",
  "https://github.com/Vimjas/vim-python-pep8-indent",
  -- "https://github.com/altermo/ultimate-autopair.nvim",
})

vim.pack.add({
  {
    src     = "https://github.com/maneyko/nvim-treesitter-rails",
    version = "vim-ruby-generic-captures-v2",
  }
})

vim.pack.add({ "https://github.com/YaroSpace/lua-console.nvim" })
require("lua-console").setup({
  mappings = {
    toggle      = "<leader>`",
    -- attach      = "<leader>t",  -- This shortcut is global
    messages    = "<nop>",
    save        = "<leader>s",
    load        = "<leader>l",
    resize_up   = "<nop>",
    resize_down = "<nop>",
  }
})

-- Motions for do..end blocks
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

-- vim.pack.add({ "https://github.com/tpope/vim-markdown" })
-- vim.g.markdown_fenced_languages = { "bash=sh", "jq", "html", "python", "ruby", "sql", "yaml", "perl", "diff", "groovy", "lua", "javascript" }
-- vim.g.markdown_syntax_conceal = 0

vim.pack.add({ "https://github.com/junegunn/vim-easy-align" })
vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { remap = false })
vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { remap = false }) -- Visual-only mode, not select mode

vim.pack.add({ "https://github.com/ZhiyuanLck/smart-pairs" })
require("pairs"):setup({
  enable_smart_space = true,
  pairs = {
    ["*"] = {
      {"(", ")"},
      {"[", "]"},
      {"{", "}"},
      {"'", "'"},
      {'"', '"'},
      {"`", "`"},
    }
  }
})

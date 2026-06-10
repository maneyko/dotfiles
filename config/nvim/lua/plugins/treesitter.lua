vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },

  -- Dependencies
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
})

local opts = {
  ensure_installed = {
    "astro",
    "bash",
    "blade",
    "c",
    "comment",
    "cpp",
    "css",
    "diff",
    "elixir",
    "eex",
    "heex",
    "git_rebase",
    "gitcommit",
    "gitignore",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "jsonc",
    "lua",
    "markdown",
    "markdown_inline",
    "pug",
    "python",
    "regex",
    "ruby",
    "rust",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  },
  highlight = { enable = true, use_languagetree = true },
  indent = { enable = true },
  rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function()
    require("nvim-treesitter").setup(opts)
  end,
})

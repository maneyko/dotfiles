vim.api.nvim_create_user_command("TSInit", function(_)
  vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    -- Dependencies
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
  })

  require("nvim-treesitter").setup({})
end, {
  desc = "Initialize treesitter plugin (for TSInstall)"
})

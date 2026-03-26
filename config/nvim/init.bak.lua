vim.api.nvim_create_autocmd('FileType', {
  pattern = { '*.py' },
  callback = function()
      vim.treesitter.start()
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

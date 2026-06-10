vim.lsp.config("ruby-lsp", {
  cmd          = { "ruby-lsp" },
  filetypes    = { "ruby", "eruby" },
  root_markers = { "Gemfile", ".git" },
})

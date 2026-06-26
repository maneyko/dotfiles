local utils = require("config.utils")

vim.treesitter.query.add_predicate("is-rspec?", function(_, _, bufnr, _)
  local fname = vim.api.nvim_buf_get_name(bufnr)

  return (
    vim.endswith(fname, "_spec.rb") or
    utils.substr_exists(fname, "/spec/")
  )
end, { force = true })

vim.treesitter.query.add_predicate("is-ruby-request-spec?", function(_, _, bufnr, _)
  local fname = vim.api.nvim_buf_get_name(bufnr)

  return (
    utils.substr_exists(fname, "/spec/requests/") or
    utils.substr_exists(fname, "/spec/controllers/")
  )
end, { force = true })

vim.treesitter.query.add_predicate("is-active-record?", function(_, _, bufnr, _)
  local fname = vim.api.nvim_buf_get_name(bufnr)

  return utils.substr_exists(fname, "/app/models/")
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-controller?", function(_, _, bufnr, _)
  local fname = vim.api.nvim_buf_get_name(bufnr)

  return utils.substr_exists(fname, "/app/controllers/")
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-migration?", function(_, _, bufnr, _)
  local fname = vim.api.nvim_buf_get_name(bufnr)

  return utils.substr_exists(fname, "/db/migrate/")
end, { force = true })

vim.treesitter.query.add_predicate("is-ruby-rake?", function(_, _, bufnr, _)
  local fname = vim.api.nvim_buf_get_name(bufnr)

  return (
    vim.endswith(fname, ".rake") or
    vim.endswith(fname, "Rakefile")
  )
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-routes?", function(_, _, bufnr, _)
  local fname = vim.api.nvim_buf_get_name(bufnr)

  return vim.endswith(fname, "/config/routes.rb")
end, { force = true })

vim.treesitter.query.add_predicate("is-rails-view?", function(_, _, bufnr, _)
  local fname = vim.api.nvim_buf_get_name(bufnr)

  return (
    utils.substr_exists(fname, "/app/helpers/") or
    utils.substr_exists(fname, "/app/views/")
  )
end, { force = true })

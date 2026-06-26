local utils = require("config.utils")

-- local disable_treesitter = {
--   "markdown",
--   "ruby",
-- }

local enable_treesitter = {
  "dockerfile",
  "json",
  "lua",
  "ruby",
  "python",
  "sh",
  "terraform",
  "query", -- .scm files for Neovim
}

vim.g.ts_enabled = true -- Neovim enables treesitter by default

require("config.treesitter.predicates.bash.is-posix")

vim.api.nvim_create_user_command("TSStart", function(options)
  if not vim.g.ts_init_ran then
    vim.cmd.TSInit()
    vim.g.ts_init_ran = true
  end
  vim.treesitter.start(vim.api.nvim_get_current_buf())
  vim.g.ts_enabled = true
  if not options.bang then
    utils.echo_info("Treesitter enabled", 1500)
  end
end, { bang = true, desc = "Start treesitter" })

vim.api.nvim_create_user_command("TSStop", function(options)
  vim.treesitter.stop(vim.api.nvim_get_current_buf())
  vim.g.ts_enabled = false
  if not options.bang then
    utils.echo_info("Treesitter disabled", 1500)
  end
end, { bang = true, desc = "Stop treesitter" })

utils.autocmd_file_loaded({
  name = "Disable treesitter by default",
  pattern = "*",
  callback = function()
    if not vim.tbl_contains(enable_treesitter, vim.bo.filetype) then
      vim.cmd.TSStop({ bang = true })
    end
  end
})

utils.autocmd_file_loaded({
  name = "Enable treesitter for specific filetypes",
  pattern = enable_treesitter,
  callback = function() vim.cmd.TSStart() end,
})

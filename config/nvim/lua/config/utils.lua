local M = {}

function M.init_plugins()
  require("plugins.catppuccin")
  require("plugins.completion") -- breaks function..end in Lua
  require("plugins.core")
  require("plugins.file_tree")
  require("plugins.fzf")
  require("plugins.mini")
  require("plugins.snacks")
  require("plugins.treesitter")

  -- M.load_lazy(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

  -- require("lazy").setup({
  --   spec = {
  --     -- import your plugins
  --     { import = "plugins" },
  --   },
  --   defaults = {
  --     lazy = false,
  --   },
  --   -- Configure any other settings here. See the documentation for more details.
  --   -- colorscheme that will be used when installing plugins.
  --   install = { colorscheme = { "habamax" } },
  --   -- automatically check for plugin updates
  --   checker = {
  --     enabled = true,
  --     notify = false,
  --   },
  --   change_detection = {
  --     notify = false,
  --   },
  -- })

end

function M.load_lazy(path)
  if not (vim.uv or vim.loop).fs_stat(path) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, path })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(path)
end

-- https://github.com/neovim/neovim/discussions/37122#discussioncomment-15352797
function M.stop_lsps(info)
  local client_names = info.fargs

  -- Default to disabling all servers on current buffer
  if #client_names == 0 then
    client_names = vim
      .iter(vim.lsp.get_clients())
      :map(function(client)
        return client.name
      end)
      :totable()
  end

  for name in vim.iter(client_names) do
    if vim.lsp.config[name] == nil then
      vim.notify(("Invalid server name '%s'"):format(name))
    else
      vim.lsp.enable(name, false)
      if info.bang then
        vim.iter(vim.lsp.get_clients({ name = name })):each(function(client)
          client:stop(true)
        end)
      end
    end
  end
end

return M

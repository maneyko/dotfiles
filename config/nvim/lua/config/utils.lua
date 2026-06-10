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

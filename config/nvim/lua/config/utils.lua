local M = {}

M.substr_exists = function(str, substr)
  return string.find(str, substr, 1, true) ~= nil
end

M.sleep_and_clear = function(milliseconds)
  vim.defer_fn(function() print("") end, milliseconds)
end

M.echo_info = function(message, display_timeout_ms)
  display_timeout_ms = display_timeout_ms or 2000
  vim.api.nvim_echo({{message, "MoreMsg"}}, true, {})
  M.sleep_and_clear(display_timeout_ms)
end

local state = {}
vim.g.autocmd_file_loaded_table = {}
M.autocmd_file_loaded = function(options)
  vim.api.nvim_create_autocmd({
    "BufReadPost",
    "BufNewFile",
    "BufEnter",
  }, {
    pattern = "*",
    callback = function()
      local key = options["name"]..vim.api.nvim_get_current_buf()
      if state[key] then
        return
      else
        state[key] = true
      end
      if vim.bo.filetype == "" then
        vim.cmd("filetype detect")
      end
      local pattern = options["pattern"]
      if type(pattern) ~= "table" then
        pattern = { pattern }
      end
      if options["pattern"] ~= "*" and not vim.tbl_contains(pattern, vim.bo.filetype) then
        return
      end
      options["callback"]()
    end
  })
end

-- https://github.com/neovim/neovim/discussions/37122#discussioncomment-15352797
M.stop_lsps = function(info)
-- function M.stop_lsps(info)
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

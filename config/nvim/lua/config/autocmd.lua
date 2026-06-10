-- Show trailing spaces in normal mode
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.o.list = true
  end,
})

-- Do not show trailing spaces in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.o.list = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.treesitter.stop()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "terraform-vars",
  callback = function()
    vim.opt.filetype = "terraform"
  end,
})

local function sleep_and_clear(seconds)
  vim.defer_fn(function() print("") end, seconds * 1000)
end

-- Simply notify that the LSP has been enabled
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    if vim.lsp.get_client_by_id(ev.data.client_id) then
      vim.api.nvim_echo({{"LSP is enabled", "MoreMsg"}}, true, {})
      sleep_and_clear(5)
    end
  end
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      -- vim.keymap.del("n", "K")
      local bufnr = vim.api.nvim_get_current_buf()
      vim.keymap.set("n", "K", "<cmd>tab split | lua vim.lsp.buf.definition()<cr>", { buf = bufnr })
      -- vim.keymap.set("n", "K", function()
      --   vim.cmd("tab split")
      --   vim.lsp.buf.definition()
      -- end)

      vim.keymap.set("n", ";", "<cmd>lua vim.lsp.buf.hover()<cr>", { buf = bufnr })
      -- vim.keymap.set('n', ';', function()
      --   vim.lsp.buf.hover()
      -- end, { desc = 'vim.lsp.buf.hover()' })

      -- Disable syntax highlighting
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

-- Highlight Sorbet signatures as comments
vim.api.nvim_set_hl(0, "RubySigComment",  { link = "rubyComment" })
vim.api.nvim_set_hl(0, "RubySigDoRegion", { link = "rubyComment" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.keymap.set("n", "K", function()
      vim.lsp.enable("ruby-lsp")
    end)
    vim.fn.matchadd("RubySigComment",  [[\<sig\s*do\>]], 200)
    vim.fn.matchadd("RubySigDoRegion", [[\<sig\s*do\>\_.\{-}\<end\>]], 200)
    -- vim.treesitter.stop()
  end,
})

-- Open diagnostics float on hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = { "CursorMoved", "CursorMovedI", "BufLeave" },
      source = "always", -- Shows the source of the warning (e.g., lua_ls)
      prefix = " ",
      scope = "cursor",
    })
  end,
})

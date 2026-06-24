-- Print info about the current clients:
-- print(vim.inspect(vim.lsp.get_clients({ bufnr = 0  })))

local utils = require("config.utils")

local lsp_names = {
  -- "bashls",
  "lua_ls",
  "pylsp",
  -- "ruby-lsp",
  -- "solargraph",
  -- "rubocop",
  -- "sorbet",
  -- "typeprof",
}


vim.api.nvim_create_user_command("LSPShowClients", function(_)
  print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))
end, {
  desc = "Show all LSP clients"
})

vim.api.nvim_create_user_command("LSPStart", function(_)
  for _, lsp_name in ipairs(lsp_names) do
    vim.lsp.enable(lsp_name)
  end
end, { desc = "Start LSP server" })

vim.api.nvim_create_user_command("LSPStopAll", function(_)
  utils.stop_lsps({fargs = {}, bang = true})
end, {
  desc = "Stop all LSP servers"
})

-- Simply notify that the LSP has been enabled
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    if vim.lsp.get_client_by_id(ev.data.client_id) then
      utils.echo_info("LSP is enabled", 2000)
    end
  end
})

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(ev)
--     local client = vim.lsp.get_client_by_id(ev.data.client_id)
--     if client then
--       -- vim.keymap.del("n", "K")
--       local bufnr = vim.api.nvim_get_current_buf()
--       vim.keymap.set("n", "K", "<cmd>tab split | lua vim.lsp.buf.definition()<cr>", { desc = "Open definition in new tab", buf = bufnr })
--       vim.keymap.set("n", "<C-space>", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "View definition", buf = bufnr })
--
--       -- Disable syntax highlighting
--       -- client.server_capabilities.semanticTokensProvider = nil
--       -- print(vim.inspect(client.server_capabilities))
--     end
--   end,
-- })

-- local function make_conf(...)
--   local capabilities = vim.lsp.protocol.make_client_capabilities()
--   capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
--   return vim.tbl_deep_extend("force", {
--     capabilities = capabilities,
--   }, ...)
-- end

vim.lsp.config("ruby-lsp", {
  cmd          = { "ruby-lsp" },
  filetypes    = { "ruby", "eruby" },
  root_markers = { "Gemfile", ".git" },
  init_options = {
    formatter = "standard",
    linters = { "standard" },
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false,
      },
    },
  }
})

-- All options: https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
vim.lsp.config("pylsp", {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          -- https://pycodestyle.pycqa.org/en/latest/intro.html#error-codes
          ignore = {
            -- "E111",  -- Allow indent of 2
          },
          maxLineLength = 120
        }
      }
    }
  }
})

vim.lsp.config("bashls", {})
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "redis", "vim" }
      }
    }
  }
})

vim.cmd.LSPStart()

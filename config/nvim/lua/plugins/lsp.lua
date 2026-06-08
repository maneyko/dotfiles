
local function make_conf(...)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

  return vim.tbl_deep_extend("force", {
    capabilities = capabilities,
  }, ...)
end

return {
  "neovim/nvim-lspconfig",
  cond = false,
  config = function()
    vim.lsp.config(
      "lua_ls",
      make_conf({
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            telemetry = { enable = false },
            hint = { enable = true },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            codeLens = {
              enable = true,
            },
            diagnostics = {
              globals = { "vim" },
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      })
    )
    vim.lsp.enable("lua_ls")
  end
}

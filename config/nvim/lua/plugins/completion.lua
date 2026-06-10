vim.pack.add { { src = "https://github.com/saghen/blink.cmp" } }

-- Dependencies
vim.pack.add { { src = "https://github.com/saghen/blink.lib" } }
vim.pack.add { { src = "https://github.com/rafamadriz/friendly-snippets" } }

require("blink.cmp").setup({
  keymap = {
    preset = "none", -- Use 'none' to have full control
    ["<C-j>"] = { "select_next" },
    ["<C-k>"] = { "select_prev" },
    -- ["<CR>"] = { "accept", "fallback" }, -- Accept completion like Tab
    ["<Tab>"] = { "accept", "fallback" }, -- Use Tab to accept
    ["<C-y>"] = { "select_and_accept" },
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<Esc>"] = {
      function(cmp)
        if cmp.is_visible() then
          cmp.cancel()
        end
      end,
      "fallback",
    },
  },
  -- completion = { documentation = { auto_show = false } },
  fuzzy = { implementation = "prefer_rust" },
  -- Disable for '/' search
  cmdline = {
    enabled = false,
  }
})

require("plugins.lsp")

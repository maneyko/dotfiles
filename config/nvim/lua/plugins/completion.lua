-- return {}
return {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = {
    "saghen/blink.lib",
    -- optional: provides snippets for the snippet source
    "rafamadriz/friendly-snippets",
  },
  build = function()
    -- build the fuzzy matcher, optionally add a timeout to `pwait(timeout_ms)`
    -- you can use `gb` in `:Lazy` to rebuild the plugin as needed
    require("blink.cmp").build():pwait()
  end,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
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
  },
}

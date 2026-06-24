vim.pack.add({
  "https://github.com/saghen/blink.cmp",

  -- Dependencies
  "https://github.com/saghen/blink.lib",
  "https://github.com/rafamadriz/friendly-snippets"
})

require("blink.cmp").setup({
  keymap = {
    preset = "none", -- Use 'none' to have full control
    ["<C-j>"]   = { "select_next", "fallback" },
    ["<C-k>"]   = { "select_prev", "fallback" },
    ["<Tab>"]   = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },

    ["<C-y>"]     = { "accept", "snippet_forward" },
    ["<C-space>"] = { "accept", "snippet_forward" },
    -- ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
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
  cmdline = { enabled = false },
  completion = {
    list = {
      selection = { preselect = false, auto_insert = true },
    },
    accept = { auto_brackets = { enabled = false } },
    trigger = {
      show_on_accept_on_trigger_character = false,
    }
  },
})

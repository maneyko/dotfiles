vim.pack.add({
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = vim.version.range("3") },

  -- Dependencies
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

vim.keymap.set("n", "<leader>n", "<cmd>Neotree toggle reveal_force_cwd<cr>", { desc = "Toggle file drawer" })

require("neo-tree").setup({
  close_if_last_window = true,
  bind_to_cwd = false,
  default_component_configs = {
    indent = {
      last_indent_marker = "└ ",
    },
    icon = {
      folder_closed     = ">",
      -- folder_open = "⋁",
      folder_open = "v",
      -- folder_open       = "˅⌄",
      -- folder_open = "",
      -- folder_closed = "",
      folder_empty      = "o",
      folder_empty_open = "o",
    }
  },
  window = {
    mappings = {
      ["<cr>"] = "open_tabnew",
    }
  }
})

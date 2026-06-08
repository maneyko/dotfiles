return {
  {
    "nvim-mini/mini.nvim",
    version = "*",
    config = function()
      require("mini.align").setup({})
      require("mini.comment").setup({})
      -- Better surround
      -- - saiw) - [S]urround [A]dd [I]n [W]ord with )
      -- - sd' - [S]urround [D]elete '
      -- - sr)'' - [S]urround [R]eplace ) with (

      require("mini.surround").setup({
        mappings = {
          add       = "ys",
          delete    = "ds",
          find      = "",
          find_left = "",
          highlight = "",
          replace   = "cs",
        }
      })
      -- Remap adding surrounding to Visual mode selection
      vim.keymap.del("x", "ys")
      vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add("visual")<CR>]], { silent = true })
      -- Make special mapping for "add surrounding for line"
      vim.keymap.set("n", "yss", "ys_", { remap = true })

      require("mini.pairs").setup()
    end,
  },
}

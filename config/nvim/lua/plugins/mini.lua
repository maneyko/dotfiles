vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- require("mini.align").setup({})
require("mini.comment").setup({})
-- Better surround
-- - saiw) - [S]urround [A]dd [I]n [W]ord with )
-- - sd' - [S]urround [D]elete '
-- - sr)'' - [S]urround [R]eplace ) with (

require("mini.surround").setup({
  -- after_surround_cursor_position = "after_left_surrounding",
  after_surround_cursor_position = "left_surrounding",
  -- after_surround_cursor_position = "right_surrounding",
  -- after_surround_cursor_position = "before_right_surrounding",
  -- respect_selection_type = true,
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

-- require("mini.pairs").setup()

-- MiniPairs.open("()", )

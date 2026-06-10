-- function _maneyko_theme_config()
--   require("telescope.themes").get_ivy({layout_config={height=0.3}})
-- end
--
local height = 0.3

vim.pack.add({
  { src = "https://github.com/nvim-telescope/telescope.nvim" },

  -- Dependencies
  { src = "https://github.com/nvim-lua/plenary.nvim" },

  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
})

vim.keymap.set("n", "<C-p>",     function() require("telescope.builtin").find_files( require("telescope.themes").get_ivy({layout_config={height=height}})) end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>m", function() require("telescope.builtin").oldfiles(   require("telescope.themes").get_ivy({layout_config={height=height}})) end, { desc = "Find MRU files" })
vim.keymap.set("n", "<leader>a", function() require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({layout_config={height=height}})) end, { desc = "Find matches under cursor" })
vim.keymap.set("n", "<leader>s", function() require("telescope.builtin").live_grep(  require("telescope.themes").get_ivy({layout_config={height=height}})) end, { desc = "Find using live grep" })

local actions = require("telescope.actions")
local sorters = require("telescope.sorters")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<Esc>"] = actions.close, -- don't go into normal mode, just close
        ["<C-j>"] = actions.move_selection_next, -- scroll the list with <c-j>
        ["<C-k>"] = actions.move_selection_previous, -- scroll the list with <c-k>
        -- ["<C-\\->"] = actions.select_horizontal, -- open selection in new horizantal split
        -- ["<C-\\|>"] = actions.select_vertical, -- open selection in new vertical split
        ["<C-t>"] = actions.select_tab, -- open selection in new tab
        ["<CR>"]  = actions.select_tab, -- open selection in new tab
        -- ["<C-y>"] = actions.preview_scrolling_up,
        -- ["<C-e>"] = actions.preview_scrolling_down,
      },
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim",
    },
    sorting_strategy = "ascending",
    file_sorter = sorters.get_fuzzy_file,
  },
})

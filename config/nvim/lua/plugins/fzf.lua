-- function _maneyko_theme_config()
--   require("telescope.themes").get_ivy({layout_config={height=0.3}})
-- end
--
local height = 0.3

return {
  "nvim-telescope/telescope.nvim", version = "*",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- optional but recommended
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = function()
    return {
      { "<leader>ff", function() require("telescope.builtin").find_files(require("telescope.themes").get_ivy({layout_config={height=height}})) end, desc = "Find Files" },
      { "<C-p>",      function() require("telescope.builtin").find_files(require("telescope.themes").get_ivy({layout_config={height=height}})) end, desc = "Find Files" },
      { "<leader>fo", function() require("telescope.builtin").oldfiles(  require("telescope.themes").get_ivy({layout_config={height=height}})) end, desc = "Find MRU files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep( require("telescope.themes").get_ivy({layout_config={height=height}})) end, desc = "Find using live grep" },
      -- { "<C-p>", "<cmd>Telescope find_files theme=ivy<cr>", desc = "Find Files" },
      -- { "<leader>fo", "<cmd>Telescope oldfiles theme=ivy<cr>", desc = "Find MRU files" },
      -- { "<leader>fg", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find using live grep" },
    }
  end,
  opts = function()
    local actions = require("telescope.actions")

    return {
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
      }
    }
  end,
}

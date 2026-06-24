local height = 0.3

-- Search syntax:
-- https://junegunn.github.io/fzf/search-syntax/

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
      vim.system({ "cmake", "-S.", "-Bbuild", "-DCMAKE_BUILD_TYPE=Release" }, { cwd = ev.data.path }, function(obj)
        if obj.code ~= 0 then
          vim.notify "cmake --build failed for telescope-fzf-native.nvim"
        else
          vim.system({ "cmake", "--build", "build", "--config", "Release", "--target", "install" }, { cwd = ev.data.path })
        end
      end)
    end
  end,
})

vim.api.nvim_create_user_command("PackClean", function(_)
  local active_plugins = {}
  local unused_plugins = {}

  for _, plugin in ipairs(vim.pack.get()) do
    active_plugins[plugin.spec.name] = plugin.active
  end

  for _, plugin in ipairs(vim.pack.get()) do
    if not active_plugins[plugin.spec.name] then
      table.insert(unused_plugins, plugin.spec.name)
    end
  end

  if #unused_plugins == 0 then
    print("No unused plugins.")
    return
  end

  local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.pack.del(unused_plugins)
  end
end, { desc = "Remove unused packages" }
)

vim.pack.add({
  "https://github.com/nvim-telescope/telescope.nvim",

  -- Dependencies
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
})

local function merge(...)
  return vim.tbl_deep_extend("force", ...)
end

local builtin = require("telescope.builtin")

local opts = { layout_config = { height = height } }
local theme = require("telescope.themes")

local function make_conf(extra_opts)
  return theme.get_ivy(merge(opts, extra_opts))
end

-- theme.get_ivy(deep_merge(opts, { results_title = "Find Files" }))
-- theme.get_ivy(deep_merge(opts, { results_title = "Find MRU Files" }))
-- theme.get_ivy(deep_merge(opts, { results_title = "Find matches under cursor" }))
-- theme.get_ivy(deep_merge(opts, { results_title = "Find using live grep" }))

vim.keymap.set("n", "<C-p>",     function() builtin.find_files( make_conf({ results_title = "Find Files" }))                end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>m", function() builtin.oldfiles(   make_conf({ results_title = "Find MRU Files" }))            end, { desc = "Find MRU files" })
vim.keymap.set("n", "<leader>f", function() builtin.grep_string(make_conf({ results_title = "Find matches under cursor" })) end, { desc = "Find matches under cursor" })
vim.keymap.set("n", "<leader>a", function() builtin.live_grep(  make_conf({ results_title = "Find using live grep" }))      end, { desc = "Find using live grep" })

local actions = require("telescope.actions")
local sorters = require("telescope.sorters")

local deprioritize_substrs = {
  "/spec/",
  "/test/",
  "_spec.rb",
}

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<Esc>"] = actions.close, -- don"t go into normal mode, just close
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
    tiebreak = function(current_entry, existing_entry)
      for _, pat in ipairs(deprioritize_substrs) do
        if current_entry.path:find(pat, 1, true) then
          return false
        end
      end

      return current_entry.path:len() < existing_entry.path:len()
    end,
    -- path_display = { "filename_first" }
    -- sorting_strategy = "descending",
    sorting_strategy = "descending",
    -- selection_strategy = "limit"
    -- file_sorter = sorters.fuzzy_with_index_bias,
  },
  extensions = {
    fzf = {
      fuzzy = true
    }
  }
})

require("telescope").load_extension("fzf")

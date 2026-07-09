local utils = require("config.utils")

-- Show trailing spaces in normal mode
vim.api.nvim_create_autocmd("InsertLeave", { callback = function() vim.o.list = true end })
-- Do not show trailing spaces in insert mode
vim.api.nvim_create_autocmd("InsertEnter", { callback = function() vim.o.list = false end })

local filetype_aliases = {
  json      = { "jsonl" },
  terraform = { "tf", "terraform-vars" },
}

for target, patterns in pairs(filetype_aliases) do
  utils.autocmd_file_loaded({
    name = "Handle ft alias "..target,
    pattern = patterns,
    callback = function()
      vim.opt.filetype = target
      vim.cmd("syntax on")
    end
  })
end

-- Open diagnostics float on hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      scope        = "cursor",
      focusable    = false,
      close_events = { "CursorMoved", "CursorMovedI", "BufLeave" },
      source       = "always", -- Shows the source of the warning (e.g., lua_ls)
      prefix       = " ",
    })
  end,
})

utils.autocmd_file_loaded({
  name = "Ruby 'K' definition lookup",
  pattern = "ruby",
  callback = function()
    -- First attempt at 'K' just enables the LSP
    -- vim.keymap.set("n", "K", function() vim.lsp.enable("ruby-lsp") end, { desc = "Enable Ruby LSP" })
    vim.keymap.set("n", "K", ":tabfind <Plug><cfile><cr>", { desc = "Open definition in new tab", silent = true })
  end
})

local function cd_to_git_root()
  -- Get the full path of the current file
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then return end

  local pwd = vim.fn.getcwd()
  local current_dir = current_file:match("(.*[/\\])")
  vim.api.nvim_set_current_dir(current_dir)

  -- Find the directory containing the .git folder
  -- local git_root = vim.fs.find(".git", { path = current_file, upward = true })[1]
  local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")

  if git_root ~= "" then
    -- Convert '.git' path back to its parent directory path
    -- local root_dir = vim.fs.dirname(git_root)
    vim.api.nvim_set_current_dir(git_root)
  else
    vim.api.nvim_set_current_dir(pwd)
  end
end

-- Create an autocommand to trigger this on file navigation
vim.api.nvim_create_autocmd("BufEnter", {
  callback = cd_to_git_root,
})

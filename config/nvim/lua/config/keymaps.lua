local utils = require("config.utils")

vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })
vim.keymap.set("i", "jk", "<esc>", { desc = "Exit insert mode" })

vim.keymap.set("n", "<leader><leader>", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>kq", "<cmd>q!<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")
vim.keymap.set("n", "<leader>r", "<cmd>restart<cr>")
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "<C-b>", "<cmd>nohl<cr><C-l>")
vim.keymap.set("n", "U", "<cmd>redo<cr>")
vim.keymap.set("n", "<C-r>", "<nop>")

vim.keymap.set("n", "<leader>s", function()
  vim.o.spell = not vim.o.spell
  if vim.o.spell then
    utils.echo_info("Spellcheck enabled")
  else
    utils.echo_info("Spellcheck disabled")
  end
end, { desc = "Toggle spellcheck" })

vim.keymap.set("n", "\\w", ":%s/\\s\\+$//g<CR>", { silent = true, desc = "Trim trailing whitespace" })
vim.keymap.set("n", "\\a", "0100lf<space>r<cr>", { silent = true, desc = "Align row to width of 100" })

for _, n in ipairs({ "", "2-", "3-", "4-" }) do
  vim.keymap.set({"n", "i", "v"}, "<"..n.."ScrollWheelLeft>",  "<nop>", { silent = true })
  vim.keymap.set({"n", "i", "v"}, "<"..n.."ScrollWheelRight>", "<nop>", { silent = true })
  vim.keymap.set({"n", "i", "v"}, "<"..n.."ScrollWheelUp>",    "<C-y>", { silent = true })
  vim.keymap.set({"n", "i", "v"}, "<"..n.."ScrollWheelDown>",  "<C-e>", { silent = true })
end

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Select window to the left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Select window to the right" })
vim.keymap.set("n", "<C-i>", "<cmd>tabprevious<cr>", { desc = "Go to tab to the left" })
vim.keymap.set("n", "<C-o>", "<cmd>tabnext<cr>",     { desc = "Go to tab to the right" })
vim.keymap.set("n", "<C-w><C-i>", "<cmd>tabmove -1<cr>", { desc = "Move tab left" })
vim.keymap.set("n", "<C-w><C-o>", "<cmd>tabmove +1<cr>", { desc = "Move tab right" })

-- Insert-mode readline bindings
vim.keymap.set("i", "<C-a>",     "<C-o>^",  { desc = "Beginning of line" })
vim.keymap.set("i", "<C-e>",     "<C-o>$",  { desc = "End of line" })
vim.keymap.set("i", "<C-d>",     "<C-o>x",  { desc = "Delete char" })
vim.keymap.set("i", "<C-j>",     "<C-o>j",  { desc = "Down" })
vim.keymap.set("i", "<C-n>",     "<C-o>j",  { desc = "Down" })
vim.keymap.set("i", "<C-k>",     "<C-o>d$", { desc = "Kill line" })
vim.keymap.set("i", "<C-w>",     "<C-o>dW", { desc = "Backward kill word" })
vim.keymap.set("i", "<C-p>",     "<C-o>k",  { desc = "Up" })
vim.keymap.set("i", "<C-b>",     "<C-o>B",  { desc = "Backward word" })
vim.keymap.set("i", "<C-f>",     "<C-o>W",  { desc = "Forward word" })
vim.keymap.set("c", "<M-Left>",  "<C-o>b",  { desc = "Backward word" })
vim.keymap.set("c", "<M-Right>", "<C-o>w",  { desc = "Forward word" })
-- Command-mode readline bindings
vim.keymap.set("c", "<C-a>",     "<Home>",    { desc = "Beginning of line" })
vim.keymap.set("c", "<C-d>",     "<Del>",     { desc = "Delete char" })
vim.keymap.set("c", "<C-f>",     "<S-Right>", { desc = "Forward word" })
vim.keymap.set("c", "<C-b>",     "<S-Left>",  { desc = "Backward word" })
vim.keymap.set("c", "<M-Left>",  "<S-Left>",  { desc = "Backward word" })
vim.keymap.set("c", "<M-bs>",    "<C-w>",     { desc = "Backward delete word" })
vim.keymap.set("c", "<M-Right>", "<S-Right>", { desc = "Forward word" })

vim.cmd([[
fun CmdlineKillLine()
  let l:pos = getcmdpos()
  if pos == 1 | return "" | endif
  return getcmdline()[:pos-2]
endfun
]])
-- https://neovim.io/doc/user/cmdline/#_1.-command-line-editing
vim.keymap.set("c", "<C-k>", "<C-\\>eCmdlineKillLine()<cr>", { desc = "Delete text from cursor to end of line" })

vim.keymap.set("n", "<Esc>", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      vim.api.nvim_win_close(win, true)
    end
  end
end, { desc = "Dismiss floating windows or clear highlights" })

vim.keymap.set("n", "<leader>d", function()
  -- print(vim.inspect(vim.diagnostic.config())) -- View current config
  vim.diagnostic.config({
    signs = not vim.diagnostic.config()["signs"]
  })
end, { desc = "Toggle diagnostic sidebar" })

vim.keymap.set("n", "<leader>t", function()
  if vim.g.ts_enabled then
    vim.cmd.TSStop()
  else
    vim.cmd.TSStart()
  end
end, { desc = "Toggle treesitter" })

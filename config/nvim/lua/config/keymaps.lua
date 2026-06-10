vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })
vim.keymap.set("i", "jk", "<esc>", { desc = "Exit insert mode" })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<leader><leader>", "<cmd>w<cr>")
vim.keymap.set("n", "<C-b>", "<cmd>nohl<cr><C-l>")
vim.keymap.set("n", "<leader>kq", "<cmd>q!<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("i", "<C-a>", "<C-o>^")
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("n", "<leader>r", "<cmd>restart<cr>")
vim.keymap.set("n", "U", "<cmd>redo<cr>")


vim.keymap.set({"n", "i", "v"}, "<ScrollWheelUp>",     "<C-y>")
vim.keymap.set({"n", "i", "v"}, "<2-ScrollWheelUp>",   "<C-y>")
vim.keymap.set({"n", "i", "v"}, "<3-ScrollWheelUp>",   "<C-y>")
vim.keymap.set({"n", "i", "v"}, "<4-ScrollWheelUp>",   "<C-y>")
vim.keymap.set({"n", "i", "v"}, "<ScrollWheelDown>",   "<C-e>")
vim.keymap.set({"n", "i", "v"}, "<2-ScrollWheelDown>", "<C-e>")
vim.keymap.set({"n", "i", "v"}, "<3-ScrollWheelDown>", "<C-e>")
vim.keymap.set({"n", "i", "v"}, "<4-ScrollWheelDown>", "<C-e>")


vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-i>", "<cmd>tabprevious<cr>")
vim.keymap.set("n", "<C-o>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "<C-w><C-i>", "<cmd>tabmove -1<cr>")
vim.keymap.set("n", "<C-w><C-o>", "<cmd>tabmove +1<cr>")

vim.keymap.set("n", ";", "<cmd>tab split | lua vim.lsp.buf.definition()<cr>")

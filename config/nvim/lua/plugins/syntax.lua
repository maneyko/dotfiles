local group = vim.api.nvim_create_augroup("SyntaxGroup", { clear = true })

-- Helm
vim.pack.add({ "https://github.com/towolf/vim-helm" }) -- Vimscript
-- vim.pack.add({"https://github.com/qvalentin/helm-ls.nvim"})
-- require("helm-ls").setup()


-- Coffeescript
vim.pack.add({ "https://github.com/phreax/vim-coffee-script" })

return {}

vim.pack.add({ "https://github.com/alex35mil/pi.nvim" })
require("pi").setup({
  layout = {
    side = {
      position = "bottom"
    },
  },
  panels = {
    prompt = { title = "PROMPT" },
    attachments = { title = "ATTACHMENTS" },
  },
  show_thinking = true,
  verbs = {
    use_defaults = false,
    pairs = {
      { "Working...", "Done" }
    },
  }
})

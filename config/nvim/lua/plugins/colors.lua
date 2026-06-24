vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

local config = require("config.colors")

require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  term_colors = true,
  styles = {
    comments = {},
    conditionals = {},
  },

-- rgb2hex() { local r=$(echo "$*" | awk -F';' '{print $1}'); local g=$(echo "$*" | awk -F';' '{print $2}'); local b=$(echo "$*" | awk -F';' '{print $3}'); printf "%x%x%x\n" "$r" "$g" "$b"; }
  color_overrides = {
    mocha = config["palette"],
  },
  custom_highlights = config["highlights"],
})

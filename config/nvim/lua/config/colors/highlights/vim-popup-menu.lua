return function(colors)
  return {
    Pmenu      = { fg = colors.fg1, bg = colors.bg2 },
    PmenuSel   = { fg = colors.bg2, bg = colors.blue, style = { "bold" } },
    PmenuSbar  = { fg = colors.none, bg = colors.bg2 },
    PmenuThumb = { fg = colors.none, bg = colors.bg4 },
  }
end

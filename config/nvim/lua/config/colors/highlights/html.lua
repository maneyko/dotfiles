return function(colors)
  return {
    htmlTag                 = { link = "colorsboxBlue" },
    htmlEndTag              = { link = "colorsboxBlue" },
    htmlTagName             = { link = "colorsboxAquaBold" },
    htmlArg                 = { link = "colorsboxAqua" },
    htmlScriptTag           = { link = "colorsboxPurple" },
    htmlTagN                = { link = "colorsboxFg1" },
    htmlSpecialTagName      = { link = "colorsboxAquaBold" },
    htmlLink                = { fg = colors.fg4, bg = colors.none, style = { "underline" } },
    htmlSpecialChar         = { link = "colorsboxOrange" },
    htmlBold                = { fg = colors.fg0, bg = colors.bg0, style = { "bold" } },
    htmlBoldUnderline       = { fg = colors.fg0, bg = colors.bg0, style = { "bold", "underline" } },
    htmlBoldUnderlineItalic = { fg = colors.fg0, bg = colors.bg0, style = { "bold", "underline", "italic" } },
    htmlUnderline           = { fg = colors.fg0, bg = colors.bg0, style = { "underline" } },
    htmlUnderlineItalic     = { fg = colors.fg0, bg = colors.bg0, style = { "underline", "italic" } },
    htmlItalic              = { fg = colors.fg0, bg = colors.bg0, style = { "italic" } },
  }
end

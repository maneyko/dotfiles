return function(colors)
  return {
    DiffChange = { fg = colors.aqua, bg = colors.bg0, style = { "reverse" } },
    DiffText   = { fg = colors.yellow, bg = colors.bg0, style = { "reverse" } },

    diffAdded   = { link = "colorsboxGreen" },
    diffRemoved = { link = "colorsboxRed" },
    diffChanged = { link = "colorsboxAqua" },
    diffFile    = { link = "colorsboxOrange" },
    diffNewFile = { link = "colorsboxYellow" },
    diffLine    = { link = "colorsboxBlue" },
  }
end

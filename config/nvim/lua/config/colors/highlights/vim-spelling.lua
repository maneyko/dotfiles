return function(colors)
  return {
    SpellCap   = { fg = colors.none, bg = colors.none, sp = colors.red, style = { "undercurl" } },
    SpellBad   = { fg = colors.none, bg = colors.none, sp = colors.blue, style = { "undercurl" } },
    SpellLocal = { fg = colors.none, bg = colors.none, sp = colors.aqua, style = { "undercurl" } },
    SpellRare  = { fg = colors.none, bg = colors.none, sp = colors.purple, style = { "undercurl" } },
  }
end

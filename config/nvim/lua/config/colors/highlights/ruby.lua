return function(colors)
  return {
    rubyStringDelimiter        = { link = "colorsboxGreen" },
    rubyInterpolationDelimiter = { link = "colorsboxAqua" },

    -- MatchBackground = { fg = colors.none, bg = colors.none, style = { "underline" } },
    -- MatchWord = { fg = colors.none, bg = colors.none },
    -- :hi MatchWord ctermbg=NONE cterm=NONE ctermfg=NONE

    ["@attribute.single.ruby"] = { link = "text" },

    ["@constant.builtin.ruby"] = { link = "colorsboxPurple" }, -- nil

    ["@constant.magic_bool.ruby"]   = { link = "colorsboxPurple" },
    ["@constant.predefined.ruby"]   = { link = "colorsboxBlue" },
    ["@constant.ruby"]              = { link = "colorsboxYellow" },
    ["@constant.string.array.ruby"] = { link = "colorsboxGreen" },
    ["@constant.symbol.array.ruby"] = { link = "colorsboxPurple" },

    ["@function.builtin.ruby"] = { link = "colorsboxAqua" },
    ["@function.call.ruby"]    = { link = "text" },

    ["@keyword.exception.ruby"] = { link = "colorsboxRed" },
    ["@keyword.exception.block.ruby"] = { link = "colorsboxRed" },
    ["@keyword.exception.rescue.ruby"] = { link = "colorsboxAqua" },
    ["@keyword.function.ruby"]  = { link = "colorsboxAqua" },
    ["@keyword.macro"]          = { link = "colorsboxAqua" },
    ["@keyword.magic"]          = { link = "colorsboxOrange" },
    ["@keyword.modifier.ruby"]  = { link = "colorsboxAqua" },
    ["@keyword.structure.ruby"] = { link = "colorsboxAqua" },
    ["@keyword.type.ruby"]      = { link = "colorsboxAqua" },

    ["@macro.keyword.ruby"] = { link = "colorsboxRed" },
    ["@macro.ruby"]         = { link = "colorsboxAqua" },

    ["@method.chained.ruby"] = { link = "text" },

    ["@punctuation.bracket.ruby"]       = { link = "text" },
    -- ["@punctuation.regex.ruby"]         = { fg = colors.flamingo, bg = colors.none },
    ["@punctuation.regex.ruby"]         = { link = "String" },
    ["@punctuation.interpolation.ruby"] = { link = "colorsboxAqua" },
    ["@punctuation.delimiter.ruby"]     = { link = "text" },

    ["@string.special.symbol.ruby"] = { link = "colorsboxPurple" },
    ["@string.regexp.ruby"]          = { link = "String" },

    ["@variable.builtin.ruby"]   = { link = "colorsboxPurple" },
    ["@variable.global.ruby"]    = { link = "colorsboxBlue" },
    ["@variable.parameter.ruby"] = { link = "text" },
    ["@variable.parameter.keyword"] = { link = "colorsboxPurple" },

    ["@test.helper.ruby"] = { link = "colorsboxGreenBold" },

    -- ["@attribute.single.ruby"] = { fg = colors.text, style = { "italic" } },

    -- ["@function.call.ruby"] = { link = "@variable.ruby" },

    -- ["@keyword.function.ruby"] = { link = "colorsboxAqua" },
    -- ["@keyword.function.ruby"] = { link = "colorsboxRed" },
    -- ["@keyword.ruby"]          = { link = "colorsboxRed" },
    -- ["@keyword.type.ruby"]     = { link = "colorsboxRed" },

    -- ["@method.chained.ruby"] = { fg = colors.text, style = { "italic" } },

    -- ["@punctuation.delimiter.ruby"] = { link = "text" },

    -- ["@string.special.symbol.ruby"] = { link = "colorsboxBlue" },
  }
end

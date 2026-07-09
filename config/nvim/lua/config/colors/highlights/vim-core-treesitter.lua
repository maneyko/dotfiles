return function(colors)
  return {
    ["@string.documentation"] = { link = "String" },
    ["@variable.member"]      = { link = "colorsboxBlue" },
    ["@module"]               = { link = "colorsboxYellow", style = {} },
    ["@label"]                = { link = "String" }, -- heredoc
    ["@keyword.type.class"]   = { link = "colorsboxAqua" },
    ["@constant.builtin.null"] = { link = "colorsboxPurple" },
    ["@function.builtin.exceptions"] = { link = "colorsboxRed" },
    ["@function.builtin.procs"] = { link = "colorsboxRed" },
    ["@function.builtin.exiting"] = { link = "colorsboxRed" },
    ["@function.builtin.querying"] = { link = "colorsboxRed" },
    ["@constant.builtin.keyword"] = { link = "colorsboxPurple" },
    ["@punctuation.delimiter.regexp"] = { link = "colorsboxGreen" },
    ["@comment.todo"] = { link = "Todo" },
    ["@punctuation.special"] = { link = "colorsboxAqua" },
    -- ["@punctuation.bracket"] = { link = "Normal" },
    -- ["@punctuation.delimiter"] = { link = "Normal" },
    -- ["@punctuation.braket"] = { fg = colors.subtext1, bg = colors.none },
    -- ["@punctuation.delimiter"] = { fg = colors.subtext1, bg = colors.none },
  }
end

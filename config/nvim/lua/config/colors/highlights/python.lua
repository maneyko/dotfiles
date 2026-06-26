return function(colors)
  return {
    pythonBuiltin     = { link = "colorsboxOrange" },
    pythonBuiltinObj  = { link = "colorsboxOrange" },
    pythonBuiltinFunc = { link = "colorsboxOrange" },
    pythonFunction    = { link = "colorsboxAqua" },
    pythonDecorator   = { link = "colorsboxRed" },
    pythonInclude     = { link = "colorsboxBlue" },
    pythonImport      = { link = "colorsboxBlue" },
    pythonRun         = { link = "colorsboxBlue" },
    pythonCoding      = { link = "colorsboxBlue" },
    pythonOperator    = { link = "colorsboxRed" },
    pythonExceptions  = { link = "colorsboxPurple" },
    pythonBoolean     = { link = "colorsboxOrange" },
    pythonDot         = { link = "colorsboxFg3" },

    ["@constant.python"]           = { link = "colorsboxYellow" },
    ["@module.python"]             = { link = "text" },
    ["@variable.parameter.python"] = { link = "text" },
    ["@variable.parameter.keyword.python"] = { link = "colorsboxPurple" },
    ["@function.call.python"]      = { fg = colors.text },
    ["@function.method.call.python"]      = { fg = colors.text },
    ["@punctuation.delimiter.period.python"] = { fg = colors.text },
    ["@punctuation.delimiter.python"] = { fg = colors.text },
    ["@constructor.python"] = { link = "text" },
    ["@keyword.type.python"] = { link = "colorsboxAqua" },
    ["@keyword.function.python"] = { link = "colorsboxAqua" },
    ["@punctuation.interpolation.python"] = { link = "colorsboxAqua" },
    ["@variable.builtin.python"] = { link = "colorsboxBlue" }, -- self
    ["@attribute.python"] = { fg = colors.blue_bright1 }, -- decorator
    ["@boolean.python"] = { link = "colorsboxOrange" },
    -- ["@variable.member.python"] = { link = "text" },
  }
end

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
    pythonBoolean     = { link = "colorsboxPurple" },
    pythonDot         = { link = "colorsboxFg3" },

    ["@constant.python"]           = { link = "colorsboxYellow" },
    ["@module.python"]             = { link = "text" },
    ["@variable.parameter.python"] = { link = "colorsboxPurple" },
    ["@constructor.foo.python"]    = { fg = colors.yellow, style = {} },
    ["@constructor.python"]        = { link = "colorsboxYellow" },
  }
end

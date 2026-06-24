return function(colors)
  return {
    -- ["@function.builtin.bash"]    = { link = "colorsboxRed", style = {} },
    ["@function.builtin.sh"]       = { link = "colorsboxRed", style = {} },
    ["@variable.bash"]             = { link = "colorsboxBlue" },
    ["@variable.parameter.bash"]   = { link = "colorsboxOrange" },
    ["@function.builtin.bash"]     = { link = "colorsboxRed" },
    ["@function.call.bash"]        = { link = "text" },
    -- ["@string.variable.bash"]      = { link = "colorsboxAqua" },
    ["@string.interpolation.bash"] = { link = "colorsboxAqua" },
    ["@string.command.bash"]       = { link = "text" },
    ["@constant.bash"] = { link = "colorsboxBlue" },
    ["@operator.bash"] = { link = "colorsboxRed" },
    ["@punctuation.special.bash"] = { link = "colorsboxAqua" },
    ["@keyword.import.bash"] = { link = "colorsboxRed" }, -- export
  }
end

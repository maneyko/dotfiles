return function(colors)
  return {
    -- ["@function.builtin.bash"]    = { link = "colorsboxRed", style = {} },
    ["@function.builtin.sh"]       = { link = "colorsboxRed", style = {} },
    ["@variable.bash"]             = { link = "colorsboxBlue" },
    ["@variable.parameter.bash"]   = { link = "colorsboxOrange" },
    ["@function.builtin.bash"]     = { link = "colorsboxRed" },
    ["@function.call.bash"]        = { fg = colors.text, bg = colors.none, style = {} },
    ["@function.posix.bash"]       = { link = "colorsboxRed" },
    ["@function.posix.flag.bash"]  = { link = "colorsboxRed" },
    -- ["@string.variable.bash"]      = { link = "colorsboxAqua" },
    ["@string.interpolation.bash"] = { link = "colorsboxAqua" },
    ["@string.command.bash"]       = { link = "text" },
    ["@constant.bash"] = { link = "colorsboxBlue" },
    ["@operator.bash"] = { link = "colorsboxRed" },
    ["@operator.assignment.bash"] = { fg = colors.text, },
    ["@operator.logical.bash"] = { fg = colors.text },
    ["@operator.pipeline.bash"] = { fg = colors.text, },
    ["@punctuation.special.bash"] = { link = "colorsboxAqua" },
    ["@keyword.import.bash"] = { link = "colorsboxRed" }, -- export

    ["@keyword.directive.bash"] = { link = "@comment" }, -- /bin/bash
    ["@punctuation.string.delimiter.bash"] = { fg = colors.text, }, -- quotation marks
    ["@punctuation.array.delimiter.bash"] = { link = "colorsboxAqua" },
    ["@command_substitution.function.call.bash"] = { link = "colorsboxOrange" },

    ["@function.arg.flag.bash"] = { fg = colors.orange },
    ["@function.arg.positional.bash"] = { fg = colors.text },

    ["@semicolon.bash"] = { fg = colors.text },
  }
end

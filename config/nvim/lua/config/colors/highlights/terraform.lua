return function(colors)
  return {
    ["@keyword.terraform"] = { link = "colorsboxYellow" },
    -- hclBraces = { link = "text" },

    -- ["@variable.builtin.terraform"] = { link = "colorsboxPurple" },
    -- ["@variable.builtin.terraform"] = { link = "Normal" },
    -- ["@variable.builtin.terraform"] = { fg = colors.maroon1 },
    ["@variable.builtin.terraform"] = { link = "Normal" },
    -- ["@variable.builtin2.terraform"] = { fg = colors.orange_muted },
    -- ["@type.builtin.terraform"] = { fg = colors.orange_muted },
    ["@variable.builtin2.terraform"] = { link = "colorsboxOrange" },
    ["@type.builtin.terraform"] = { link = "colorsboxOrange" },
    -- ["@variable.member.terraform"] = { link = "text" },
  }
end

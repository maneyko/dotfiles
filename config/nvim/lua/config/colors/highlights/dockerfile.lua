return function(colors)
  return {
    ["@property.dockerfile"] = { link = "colorsboxBlue" },
    ["@param.dockerfile"] = { link = "colorsboxOrange" }, -- COPY {--chown=myuser} foo bar
    ["@variable.dockerfile"] = { link = "colorsboxAqua" },
    ["@punctuation.special.dockerfile"] = { link = "colorsboxAqua" },
  }
end

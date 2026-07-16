return function(colors)
  return {
    ["@property.yaml"] = { link = "colorsboxBlue" },  -- keys

    ["@punctuation.delimiter.yaml"] = { link = "colorsboxOrange" }, -- colon, comma
    ["@punctuation.bracket.yaml"]   = { link = "colorsboxOrange" },  -- [], {}
    ["@constant.builtin.yaml"]      = { link = "colorsboxPurple" },  -- null scalar (~)
  }
end

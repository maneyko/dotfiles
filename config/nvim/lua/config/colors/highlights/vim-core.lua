return function(colors)
  return {
    CursorLine   = { fg = colors.none, bg = colors.bg1 },
    CursorColumn = { link = "CursorLine" },
    TabLineFill  = { fg = colors.bg4, bg = colors.bg0 },
    TabLine      = { fg = colors.bg4, bg = colors.bg0 },
    TabLineSel   = { fg = colors.bg0, bg = colors.bg4, style = { "bold" } },
    MatchParen   = { fg = colors.none, bg = colors.bg3, style = { "bold" } },
    ColorColumn  = { fg = colors.none, bg = colors.bg1 },
    Conceal      = { fg = colors.blue },
    CursorLineNr = { fg = colors.fg0, bg = colors.bg1 },

    NonText      = { link = "colorsboxBg2" },
    SpecialKey   = { link = "colorsboxBg2" },
    Visual       = { fg = colors.none, bg = colors.bg3, style = { "reverse" } },
    VisualNOS    = { link = "Visual" },
    Underlined   = { fg = colors.blue, style = { "underline" } },
    StatusLine   = { fg = colors.bg4, bg = colors.bg0, style = { "bold", "reverse" } },
    StatusLineNC = { fg = colors.bg2, bg = colors.fg4, style = { "bold", "reverse" } },
    VertSplit    = { fg = colors.fg4, bg = colors.bg2 },
    WildMenu     = { fg = colors.blue, bg = colors.bg2, style = { "bold" } },
    Directory    = { link = "colorsboxGreenBold" },
    Title        = { link = "colorsboxGreenBold" },
    ErrorMsg     = { fg = colors.bg0, bg = colors.red, style = { "bold" } },
    MoreMsg      = { link = "colorsboxYellowBold" },
    ModeMsg      = { link = "colorsboxYellowBold" },
    Question     = { link = "colorsboxOrangeBold" },
    WarningMsg   = { link = "colorsboxRedBold" },
    LineNr       = { fg = colors.gray },
    SignColumn   = { fg = colors.none, bg = colors.bg1 },
    Folded       = { fg = colors.gray, bg = colors.bg1, style = { "italic" } },
    FoldColumn   = { fg = colors.gray, bg = colors.bg1 },

    Search    = { fg = colors.bg0, bg = colors.yellow },
    IncSearch = { fg = colors.bg0, bg = colors.orange }, -- preview match while typing
    CurSearch = { link = "Search" },  -- Current search result

    Cursor    = { fg = colors.none, bg = colors.none, style = { "reverse" } },
    vCursor   = { link = "Cursor" },
    iCursor   = { link = "Cursor" },
    lCursor   = { link = "Cursor" },

    Special = { link = "colorsboxOrange" },

    Comment = { fg = colors.gray, bg = colors.none },
    Todo    = { fg = colors.fg0, bg = colors.bg0, style = { "bold" } },
    Error   = { fg = colors.red, bg = colors.bg0, style = { "bold", "reverse" } },

    Statement   = { link = "colorsboxRed" },
    Conditional = { link = "colorsboxRed" },
    Repeat      = { link = "colorsboxRed" },
    Label       = { link = "colorsboxRed" },
    Exception   = { link = "colorsboxRed" },
    Operator    = { link = "Normal" },
    Keyword     = { link = "colorsboxRed" },

    Identifier = { link = "colorsboxBlue" },
    Function   = { link = "colorsboxGreenBold" },

    PreProc      = { link = "colorsboxAqua" },
    Include      = { link = "colorsboxAqua" },
    Define       = { link = "colorsboxAqua" },
    Macro        = { link = "colorsboxAqua" },
    PreCondit    = { link = "colorsboxAqua" },
    Constant     = { link = "colorsboxPurple" },
    String       = { fg = colors.green, bg = colors.none },
    Boolean      = { link = "colorsboxPurple" },
    Number       = { link = "colorsboxPurple" },
    Float        = { link = "colorsboxPurple" },
    Type         = { link = "colorsboxYellow" },
    StorageClass = { link = "colorsboxOrange" },
    Structure    = { link = "colorsboxAqua" },
    Typedef      = { link = "colorsboxYellow" },

    -- Character    = { fg = colors.flamingo },
  }
end

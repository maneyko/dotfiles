vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  term_colors = true,
  styles = {
    comments = {},
    conditionals = {},
  },

-- rgb2hex() { local r=$(echo "$*" | awk -F';' '{print $1}'); local g=$(echo "$*" | awk -F';' '{print $2}'); local b=$(echo "$*" | awk -F';' '{print $3}'); printf "%x%x%x\n" "$r" "$g" "$b"; }
  color_overrides = {
    mocha = {

      dark0_hard = "#1c1c1c", -- orig(234 = 28;28;28)
      dark0      = "#262626", -- orig(235 = 38;38;38)
      dark0_soft = "#303030", -- orig(236 = 48;48;48)
      dark1      = "#3a3a3a", -- orig(237 = 58;58;58)
      dark2      = "#4e4e4e", -- orig(239 = 78;78;78)
      dark3      = "#626262", -- orig(241 = 98;98;98)
      dark4      = "#767676", -- orig(243 = 118;118;118)
      gray_245   = "#8a8a8a", -- orig(245 = 138;138;138)
      gray       = "#8a8a8a", -- orig(245 = 138;138;138)

      light0_hard = "#ffffd7", -- orig(230 = 255;255;211)
      light0      = "#ffffaf", -- orig(229 = 255;255;164)
      light0_soft = "#ffff87", -- orig(228 = 255;255;114)
      light1      = "#ffd7af", -- orig(223 = 255;213;169)
      light2      = "#bcbcbc", -- orig(250 = 188;188;188)
      light3      = "#a8a8a8", -- orig(248 = 168;168;168)
      light4      = "#949494", -- orig(246 = 148;148;148)

      red    = "#d75f5f", -- orig(167 = 232;85;90)
      orange = "#ff8700", -- orig(208 = 255;126;0)
      yellow = "#ffaf00", -- orig(214 = 255;171;0)
      aqua   = "#87af87", -- orig(108 = 124;176;131)
      green  = "#afaf00", -- orig(142 = 175;175;0)
      blue   = "#87afaf", -- orig(109 = 124;176;176)
      purple = "#d787af", -- orig(175 = 228;130;177)

      bg0 = "#262626", -- dark0
      bg1 = "#3a3a3a", -- dark1
      bg2 = "#4e4e4e", -- dark2
      bg3 = "#626262", -- dark3
      bg4 = "#767676", -- dark4
      fg0 = "#ffffaf", -- light0
      fg1 = "#ffd7af", -- light1
      fg2 = "#bcbcbc", -- light2
      fg3 = "#a8a8a8", -- light3
      fg4 = "#949494", -- light4

      vim_bg = "#262626", -- bg0
      vim_fg = "#ffffaf", -- fg0


      -- ------------------------------------------

      -- -- mauve = "#e0b0ff", --
      -- mauve    = "#d75f5f", -- red
      -- teal     = "#87af87", -- aqua (green) orig(124;176;131)
      -- flamingo = "#ff8700", -- orange orig(255;126;0)
      -- lavender = "#d787af", -- keymap orig(228;130;177)

      -- True neutral dark base (no blue or brown tint)
      base   = "#0B1215", -- Clean dark background
      mantle = "#1c1c1c", -- Darker
      crust  = "#161616", -- Darkest

      -- Pure grayscale text colors
      text = "#d4d4d4",
      subtext1 = "#bbbbbb",
      subtext0 = "#a6a6a6",
      overlay2 = "#919191",
      overlay1 = "#7c7c7c",
      overlay0 = "#666666",
      surface2 = "#484848",
      surface1 = "#333333",
      surface0 = "#292929",

      -- Vibrant accent colors without blue dominance
      -- red = "#d75f5f", -- orig(232;85;90)
      -- green = "#afaf00", -- text orig(175;175;0)
      -- yellow = "#ffaf00", -- orig(255;171;0)
      -- blue = "#87b0b0", -- orig(124;176;176)
      -- mauve = "#e0b0ff", -- 
      mauve    = "#d75f5f", -- red
      teal     = "#87af87", -- aqua (green) orig(124;176;131)
      flamingo = "#ff8700", -- orange orig(255;126;0)
      lavender = "#d787af", -- keymap orig(228;130;177)
      -- lavender = "#b8bb26", -- keymap

      -- Additional colors if needed
      peach     = "#ff8800",
      maroon    = "#ff6188",
      sky       = "#95e6cb",
      sapphire  = "#c07ab8",
      rosewater = "#ffa0a0",
    },
  },
  custom_highlights = function(colors)
    return {
      colorsboxFg0  = { fg = colors.fg0 },
      colorsboxFg1  = { fg = colors.fg1 },
      colorsboxFg2  = { fg = colors.fg2 },
      colorsboxFg3  = { fg = colors.fg3 },
      colorsboxFg4  = { fg = colors.fg4 },
      colorsboxGray = { fg = colors.gray },
      colorsboxBg0  = { fg = colors.bg0 },
      colorsboxBg1  = { fg = colors.bg1 },
      colorsboxBg2  = { fg = colors.bg2 },
      colorsboxBg3  = { fg = colors.bg3 },
      colorsboxRed  = { fg = colors.red },
      colorsboxRedBold    = { fg = colors.red, bg = colors.none, style = { "bold" } },
      colorsboxGreen      = { fg = colors.green },
      colorsboxGreenBold  = { fg = colors.green, bg = colors.none, style = { "bold" } },
      colorsboxYellow     = { fg = colors.yellow },
      colorsboxYellowBold = { fg = colors.yellow, bg = colors.none, style = { "bold" } },
      colorsboxBlue       = { fg = colors.blue },
      colorsboxBlueBold   = { fg = colors.blue, bg = colors.none, style = { "bold" } },
      colorsboxPurple     = { fg = colors.purple },
      colorsboxPurpleBold = { fg = colors.purple, bg = colors.none, style = { "bold" } },
      colorsboxAqua       = { fg = colors.aqua },
      colorsboxAquaBold   = { fg = colors.aqua, bg = colors.none, style = { "bold" } },
      colorsboxOrange     = { fg = colors.orange },
      colorsboxOrangeBold = { fg = colors.orange, bg = colors.none, style = { "bold" } },
      colorsboxRedSign    = { fg = colors.red,    bg = colors.bg1 },
      colorsboxGreenSign  = { fg = colors.green,  bg = colors.bg1 },
      colorsboxYellowSign = { fg = colors.yellow, bg = colors.bg1 },
      colorsboxBlueSign   = { fg = colors.blue,   bg = colors.bg1 },
      colorsboxPurpleSign = { fg = colors.purple, bg = colors.bg1 },
      colorsboxAquaSign   = { fg = colors.aqua,   bg = colors.bg1 },
      -- ---------
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
      Search       = { fg = colors.bg0, bg = colors.yellow },
      IncSearch    = { fg = colors.bg0, bg = colors.orange },
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

      Cursor  = { fg = colors.none, bg = colors.none, style = { "reverse" } },
      vCursor = { link = "Cursor" },
      iCursor = { link = "Cursor" },
      lCursor = { link = "Cursor" },

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

      Pmenu      = { fg = colors.fg1, bg = colors.bg2 },
      PmenuSel   = { fg = colors.bg2, bg = colors.blue, style = { "bold" } },
      PmenuSbar  = { fg = colors.none, bg = colors.bg2 },
      PmenuThumb = { fg = colors.none, bg = colors.bg4 },

      DiffChange = { fg = colors.aqua, bg = colors.bg0, style = { "reverse" } },
      DiffText   = { fg = colors.yellow, bg = colors.bg0, style = { "reverse" } },

      SpellCap   = { fg = colors.none, bg = colors.none, sp = colors.red, style = { "undercurl" } },
      SpellBad   = { fg = colors.none, bg = colors.none, sp = colors.blue, style = { "undercurl" } },
      SpellLocal = { fg = colors.none, bg = colors.none, sp = colors.aqua, style = { "undercurl" } },
      SpellRare  = { fg = colors.none, bg = colors.none, sp = colors.purple, style = { "undercurl" } },


      diffAdded   = { link = "colorsboxGreen" },
      diffRemoved = { link = "colorsboxRed" },
      diffChanged = { link = "colorsboxAqua" },
      diffFile    = { link = "colorsboxOrange" },
      diffNewFile = { link = "colorsboxYellow" },
      diffLine    = { link = "colorsboxBlue" },

      -- gitcommitOverflow = { link = "" },
      gitcommitSummary = { fg = colors.rosewater, style = {} },
      gitcommitSelectedFile = { link = "colorsboxGreen" },



      htmlTag                 = { link = "colorsboxBlue" },
      htmlEndTag              = { link = "colorsboxBlue" },
      htmlTagName             = { link = "colorsboxAquaBold" },
      htmlArg                 = { link = "colorsboxAqua" },
      htmlScriptTag           = { link = "colorsboxPurple" },
      htmlTagN                = { link = "colorsboxFg1" },
      htmlSpecialTagName      = { link = "colorsboxAquaBold" },
      htmlLink                = { fg = colors.fg4, bg = colors.none, style = { "underline" } },
      htmlSpecialChar         = { link = "colorsboxOrange" },
      htmlBold                = { fg = colors.fg0, bg = colors.bg0, style = { "bold" } },
      htmlBoldUnderline       = { fg = colors.fg0, bg = colors.bg0, style = { "bold", "underline" } },
      htmlBoldUnderlineItalic = { fg = colors.fg0, bg = colors.bg0, style = { "bold", "underline", "italic" } },
      htmlUnderline           = { fg = colors.fg0, bg = colors.bg0, style = { "underline" } },
      htmlUnderlineItalic     = { fg = colors.fg0, bg = colors.bg0, style = { "underline", "italic" } },
      htmlItalic              = { fg = colors.fg0, bg = colors.bg0, style = { "italic" } },

      xmlTag               = { link = "colorsboxBlue" },
      xmlEndTag            = { link = "colorsboxBlue" },
      xmlTagName           = { link = "colorsboxBlue" },
      xmlEqual             = { link = "colorsboxBlue" },
      docbkKeyword         = { link = "colorsboxAquaBold" },
      xmlDocTypeDecl       = { link = "colorsboxGray" },
      xmlDocTypeKeyword    = { link = "colorsboxPurple" },
      xmlCdataStart        = { link = "colorsboxGray" },
      xmlCdataCdata        = { link = "colorsboxPurple" },
      dtdFunction          = { link = "colorsboxGray" },
      dtdTagName           = { link = "colorsboxPurple" },
      xmlAttrib            = { link = "colorsboxAqua" },
      xmlProcessingDelim   = { link = "colorsboxGray" },
      dtdParamEntityPunct  = { link = "colorsboxGray" },
      dtdParamEntityDPunct = { link = "colorsboxGray" },
      xmlAttribPunct       = { link = "colorsboxGray" },
      xmlEntity            = { link = "colorsboxOrange" },
      xmlEntityPunct       = { link = "colorsboxOrange" },

      vimCommentTitle = { fg = colors.fg4, bg = colors.none, style = { "bold" } },

      vimNotation  = { link = "colorsboxOrange" },
      vimBracket   = { link = "colorsboxOrange" },
      vimMapModKey = { link = "colorsboxOrange" },
      vimFuncSID   = { link = "colorsboxFg3" },
      vimSetSep    = { link = "colorsboxFg3" },
      vimSep       = { link = "colorsboxFg3" },
      vimContinue  = { link = "colorsboxFg3" },

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

      cssBraces               = { link = "colorsboxBlue" },
      cssFunctionName         = { link = "colorsboxYellow" },
      cssIdentifier           = { link = "colorsboxOrange" },
      cssClassName            = { link = "colorsboxGreen" },
      cssColor                = { link = "colorsboxBlue" },
      cssSelectorOp           = { link = "colorsboxBlue" },
      cssSelectorOp2          = { link = "colorsboxBlue" },
      cssImportant            = { link = "colorsboxGreen" },
      cssVendor               = { link = "colorsboxFg1" },
      cssTextProp             = { link = "colorsboxAqua" },
      cssAnimationProp        = { link = "colorsboxAqua" },
      cssUIProp               = { link = "colorsboxYellow" },
      cssTransformProp        = { link = "colorsboxAqua" },
      cssTransitionProp       = { link = "colorsboxAqua" },
      cssPrintProp            = { link = "colorsboxAqua" },
      cssPositioningProp      = { link = "colorsboxYellow" },
      cssBoxProp              = { link = "colorsboxAqua" },
      cssFontDescriptorProp   = { link = "colorsboxAqua" },
      cssFlexibleBoxProp      = { link = "colorsboxAqua" },
      cssBorderOutlineProp    = { link = "colorsboxAqua" },
      cssBackgroundProp       = { link = "colorsboxAqua" },
      cssMarginProp           = { link = "colorsboxAqua" },
      cssListProp             = { link = "colorsboxAqua" },
      cssTableProp            = { link = "colorsboxAqua" },
      cssFontProp             = { link = "colorsboxAqua" },
      cssPaddingProp          = { link = "colorsboxAqua" },
      cssDimensionProp        = { link = "colorsboxAqua" },
      cssRenderProp           = { link = "colorsboxAqua" },
      cssColorProp            = { link = "colorsboxAqua" },
      cssGeneratedContentProp = { link = "colorsboxAqua" },

      javaScriptBraces               = { link = "colorsboxFg1" },
      javaScriptFunction             = { link = "colorsboxAqua" },
      javaScriptIdentifier           = { link = "colorsboxRed" },
      javaScriptMember               = { link = "colorsboxBlue" },
      javaScriptNumber               = { link = "colorsboxPurple" },
      javaScriptNull                 = { link = "colorsboxPurple" },
      javaScriptParens               = { link = "colorsboxFg3" },
      javascriptImport               = { link = "colorsboxAqua" },
      javascriptExport               = { link = "colorsboxAqua" },
      javascriptClassKeyword         = { link = "colorsboxAqua" },
      javascriptClassExtends         = { link = "colorsboxAqua" },
      javascriptDefault              = { link = "colorsboxAqua" },
      javascriptClassName            = { link = "colorsboxYellow" },
      javascriptClassSuperName       = { link = "colorsboxYellow" },
      javascriptGlobal               = { link = "colorsboxYellow" },
      javascriptEndColons            = { link = "colorsboxFg1" },
      javascriptFuncArg              = { link = "colorsboxFg1" },
      javascriptGlobalMethod         = { link = "colorsboxFg1" },
      javascriptNodeGlobal           = { link = "colorsboxFg1" },
      javascriptVariable             = { link = "colorsboxRed" },
      javascriptIdentifier           = { link = "colorsboxOrange" },
      javascriptClassSuper           = { link = "colorsboxOrange" },
      javascriptFuncKeyword          = { link = "colorsboxAqua" },
      javascriptAsyncFunc            = { link = "colorsboxAqua" },
      javascriptClassStatic          = { link = "colorsboxOrange" },
      javascriptOperator             = { link = "colorsboxRed" },
      javascriptForOperator          = { link = "colorsboxRed" },
      javascriptYield                = { link = "colorsboxRed" },
      javascriptExceptions           = { link = "colorsboxRed" },
      javascriptMessage              = { link = "colorsboxRed" },
      javascriptTemplateSB           = { link = "colorsboxAqua" },
      javascriptTemplateSubstitution = { link = "colorsboxFg1" },
      javascriptLabel                = { link = "colorsboxFg1" },
      javascriptObjectLabel          = { link = "colorsboxFg1" },
      javascriptPropertyName         = { link = "colorsboxFg1" },
      javascriptLogicSymbols         = { link = "colorsboxFg1" },
      javascriptArrowFunc            = { link = "colorsboxFg1" },
      javascriptDocParamName         = { link = "colorsboxFg4" },
      javascriptDocTags              = { link = "colorsboxFg4" },
      javascriptDocNotation          = { link = "colorsboxFg4" },
      javascriptDocParamType         = { link = "colorsboxFg4" },
      javascriptDocNamedParamType    = { link = "colorsboxFg4" },

      coffeeExtendedOp = { link = "colorsboxFg3" },
      coffeeSpecialOp  = { link = "colorsboxFg3" },
      coffeeCurly      = { link = "colorsboxOrange" },
      coffeeParen      = { link = "colorsboxFg3" },
      coffeeBracket    = { link = "colorsboxOrange" },

      rubyStringDelimiter        = { link = "colorsboxGreen" },
      rubyInterpolationDelimiter = { link = "colorsboxAqua" },

      ["@string.special.symbol.ruby"] = { link = "colorsboxPurple" },
      -- ["@string.special.symbol.ruby"] = { link = "colorsboxBlue" },
      ["@variable.member"]            = { link = "colorsboxBlue" },
      ["@constant.ruby"]              = { link = "colorsboxYellow" },
      -- ["@keyword.ruby"]            = { link = "colorsboxRed" },
      ["@keyword.function.ruby"]   = { link = "colorsboxAqua" },
      ["@keyword.type.ruby"]          = { link = "colorsboxAqua" },
      -- ["@keyword.function.ruby"] = { link = "colorsboxRed" },
      -- ["@keyword.type.ruby"]          = { link = "colorsboxRed" },
      -- ["@keyword.function.ruby"]      = { link = "colorsboxAqua" },
      ["@punctuation.delimiter.ruby"] = { link = "text" },
      ["@function.builtin.ruby"]      = { link = "colorsboxAqua" },
      ["@keyword.modifier.ruby"] = { link = "colorsboxAqua" },
      -- ["@function.call.ruby"] = { link = "@variable.ruby" },
      ["@function.call.ruby"] = { link = "text" },
      ["@variable.builtin.ruby"] = { link = "colorsboxPurple" },
      ["@variable.parameter.ruby"] = { link = "text" },

      -- ["@function.builtin.bash"]    = { link = "colorsboxRed", style = {} },
      ["@function.builtin.sh"]       = { link = "colorsboxRed", style = {} },
      ["@variable.bash"]             = { link = "colorsboxBlue" },
      ["@variable.parameter.bash"]   = { link = "colorsboxOrange" },
      ["@function.builtin.bash"]     = { link = "colorsboxRed" },
      ["@function.call.bash"]        = { link = "text" },
      -- ["@string.variable.bash"]      = { link = "colorsboxAqua" },
      ["@string.interpolation.bash"] = { link = "colorsboxAqua" },
      ["@string.command.bash"]       = { link = "text" },

      -- peach     = "#ff8800",
      -- maroon    = "#ff6188",
      -- sky       = "#95e6cb",
      -- sapphire  = "#c07ab8",
      -- rosewater = "#ffa0a0",

      ["@keyword.terraform"] = { link = "colorsboxYellow" },
      -- hclBraces = { link = "text" },

      ["@variable.builtin.terraform"] = { link = "text" },
      -- ["@variable.member.terraform"] = { link = "text" },

      luaIn       = { link = "colorsboxRed" },
      luaFunction = { link = "colorsboxAqua" },
      luaTable    = { link = "colorsboxOrange" },

      javaAnnotation   = { link = "colorsboxBlue" },
      javaDocTags      = { link = "colorsboxAqua" },
      javaCommentTitle = { link = "vimCommentTitle" },
      javaParen        = { link = "colorsboxFg3" },
      javaParen1       = { link = "colorsboxFg3" },
      javaParen2       = { link = "colorsboxFg3" },
      javaParen3       = { link = "colorsboxFg3" },
      javaParen4       = { link = "colorsboxFg3" },
      javaParen5       = { link = "colorsboxFg3" },
      javaOperator     = { link = "colorsboxOrange" },
      javaVarArg       = { link = "colorsboxGreen" },

      jsonKeyword = { link = "colorsboxGreen" },
      jsonQuote   = { link = "colorsboxGreen" },
      jsonBraces  = { link = "colorsboxFg1" },
      jsonString  = { link = "colorsboxFg1" },

      markdownItalic            = { fg = colors.fg3, bg = colors.none, style = { "italic" } },
      markdownH1                = { link = "colorsboxGreenBold" },
      markdownH2                = { link = "colorsboxGreenBold" },
      markdownH3                = { link = "colorsboxYellowBold" },
      markdownH4                = { link = "colorsboxYellowBold" },
      markdownH5                = { link = "colorsboxYellow" },
      markdownH6                = { link = "colorsboxYellow" },
      markdownCode              = { link = "colorsboxAqua" },
      markdownCodeBlock         = { link = "colorsboxAqua" },
      markdownCodeDelimiter     = { link = "colorsboxAqua" },
      markdownBlockquote        = { link = "colorsboxGray" },
      markdownListMarker        = { link = "colorsboxGray" },
      markdownOrderedListMarker = { link = "colorsboxGray" },
      markdownRule              = { link = "colorsboxGray" },
      markdownHeadingRule       = { link = "colorsboxGray" },
      markdownUrlDelimiter      = { link = "colorsboxFg3" },
      markdownLinkDelimiter     = { link = "colorsboxFg3" },
      markdownLinkTextDelimiter = { link = "colorsboxFg3" },
      markdownHeadingDelimiter  = { link = "colorsboxOrange" },
      markdownUrl               = { link = "colorsboxPurple" },
      markdownUrlTitleDelimiter = { link = "colorsboxGreen" },
      markdownLinkText          = { fg = colors.gray, bg = colors.none, style = { "underline" } },
      markdownIdDeclaration     = { link = "markdownLinkText" },

      -- TelescopeNormal = { bg = colors.none, fg = colors.none },
      -- TelescopeBorder = { bg = colors.none, fg = colors.none },

      TelescopeNormal = { bg = colors.none, fg = colors.fg4 },
      TelescopeBorder = { bg = colors.none, fg = colors.none },

      -- NoiceCmdlinePopup = { bg = colors.none },
      -- NoicePopup = { bg = colors.none },
      -- WhichKeyFloat = { bg = colors.none },

      -- -- Add Telescope prompt specific highlights
      -- TelescopePrompt = { bg = colors.none },
      -- TelescopePromptNormal = { bg = colors.bg0 },
      -- TelescopePromptBorder = { bg = colors.none, fg = colors.overlay0 },
      -- TelescopePromptPrefix = { bg = colors.none, fg = colors.blue },
      -- TelescopePromptTitle = { bg = colors.none, fg = colors.blue },

      -- -- Different colors for results and preview
      -- TelescopeResults = { bg = colors.none },
      -- TelescopePreview = { bg = colors.none },
      -- TelescopeResultsTitle = { bg = colors.none, fg = colors.blue },
      -- TelescopePreviewTitle = { bg = colors.none, fg = colors.blue },

      -- -- Selection highlights
      -- TelescopeSelection = { bg = colors.none, fg = colors.text },
      -- TelescopeSelectionCaret = { bg = colors.none, fg = colors.blue },


      -- Operator     = { fg = colors.text },
      -- Boolean      = { fg = colors.lavender },
      -- Number       = { fg = colors.lavender },
      -- Character    = { fg = colors.flamingo },
      -- Special      = { fg = colors.flamingo },
      -- String       = { fg = colors.green },
      -- LineNr       = { fg = colors.gray },
      -- -- Normal = { fg = colors.fg0, bg = colors.bg0 },
      -- Visual       = { fg = colors.none, bg = colors.bg3 },
      -- Search       = { fg = colors.bg0, bg = colors.yellow },
      -- IncSearch    = { fg = colors.bg0, bg = colors.orange },
      -- StatusLine   = { fg = colors.bg4, bg = colors.bg0 },
      -- StatusLineNC = { fg = colors.bg2, bg = colors.fg4 },
      -- VertSplit    = { fg = colors.fg4, bg = colors.bg2 },
    }
  end
})

local xterm_to_rgb = require("config.utils").xterm_to_rgb

return {
  -- https://coolors.co/colors

  -- Core colors
  red    = xterm_to_rgb(167),
  orange = xterm_to_rgb(208),
  yellow = xterm_to_rgb(214),
  green  = xterm_to_rgb(142),
  aqua   = xterm_to_rgb(108),
  blue   = xterm_to_rgb(109),
  purple = xterm_to_rgb(175),

  -- Accent colors
  peach     = "#ff8700",  -- Orange modifier
  maroon    = "#ff6188",  -- Red modifier
  sky       = "#95e6cb",  -- Blue modifier
  sapphire  = "#c07ab8",  -- Purple modifier

  blue_bright1 = "#87c3c3",
  blue_bright2 = "#87d7d7",

  pink      = "#f5c2e7",
  rosewater = "#ffa0a0",

  dark0_hard = xterm_to_rgb(234),
  dark0      = xterm_to_rgb(235),
  dark0_soft = xterm_to_rgb(236),
  dark1      = xterm_to_rgb(237),
  dark2      = xterm_to_rgb(239),
  dark3      = xterm_to_rgb(241),
  dark4      = xterm_to_rgb(243),
  gray_245   = xterm_to_rgb(245),
  gray       = xterm_to_rgb(245),

  light0_hard = xterm_to_rgb(230),
  light0      = xterm_to_rgb(229),
  light0_soft = xterm_to_rgb(228),
  light1      = xterm_to_rgb(223),
  light2      = xterm_to_rgb(250),
  light3      = xterm_to_rgb(248),
  light4      = xterm_to_rgb(246),

  bg0 = xterm_to_rgb(235), -- dark0
  bg1 = xterm_to_rgb(237), -- dark1
  bg2 = xterm_to_rgb(239), -- dark2
  bg3 = xterm_to_rgb(241), -- dark3
  bg4 = xterm_to_rgb(243), -- dark4
  fg0 = xterm_to_rgb(229), -- light0
  fg1 = xterm_to_rgb(223), -- light1
  fg2 = xterm_to_rgb(250), -- light2
  fg3 = xterm_to_rgb(248), -- light3
  fg4 = xterm_to_rgb(246), -- light4

  vim_bg = xterm_to_rgb(235), -- bg0
  vim_fg = xterm_to_rgb(229), -- fg0

  -- ------------------------------------------

  base   = xterm_to_rgb(233),
  mantle = xterm_to_rgb(234),
  crust  = xterm_to_rgb(233),

  -- vim comment is 245

  text     = xterm_to_rgb(252), -- if too dark try 253, Neovim original is dde0de, Vim original (and terminal) is d8d8d8
  subtext1 = xterm_to_rgb(250),
  subtext0 = xterm_to_rgb(248),
  overlay2 = xterm_to_rgb(246),
  overlay1 = xterm_to_rgb(244),
  overlay0 = xterm_to_rgb(242),
  surface2 = xterm_to_rgb(240),
  surface1 = xterm_to_rgb(238),
  surface0 = xterm_to_rgb(236),

  -- Required by plugin
  lavender = xterm_to_rgb(175), -- purple
  mauve    = xterm_to_rgb(167), -- red
  teal     = xterm_to_rgb(108), -- aqua
  flamingo = xterm_to_rgb(208), -- orange
}

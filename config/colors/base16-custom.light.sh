#!/bin/bash
# Base16 Custom - Shell color setup script
# Chris Kempson (http://chriskempson.com)

if [ "${TERM%%-*}" = 'linux' ]; then
    # This script doesn't support linux console (use 'vconsole' template instead)
    return 2>/dev/null || exit 0
fi

color00="13/13/13" # Base 00 - Black
color01="fa/44/44" # Base 08 - Red
color02="a1/b5/6c" # Base 0B - Green
color03="f7/ca/88" # Base 0A - Yellow
color04="81/95/f4" # Base 0D - Blue
color05="ba/8b/af" # Base 0E - Magenta
color06="2e/e0/b7" # Base 0C - Cyan
color07="d8/d8/d8" # Base 05 - White
color08="58/58/58" # Base 03 - Bright Black
color09=$color01 # Base 08 - Bright Red
color10=$color02 # Base 0B - Bright Green
color11=$color03 # Base 0A - Bright Yellow
color12=$color04 # Base 0D - Bright Blue
color13=$color05 # Base 0E - Bright Magenta
color14=$color06 # Base 0C - Bright Cyan
color15="f8/f8/f8" # Base 07 - Bright White
color16="dc/96/56" # Base 09
color17="a1/69/46" # Base 0F
color18="28/28/28" # Base 01
color19="38/38/38" # Base 02
color20="b8/b8/b8" # Base 04
color21="e8/e8/e8" # Base 06
color_foreground="f2/f2/f2" # Base 02
color_background="f8/f8/f8" # Base 07
color_cursor="38/38/38" # Base 02
esc="\033"

if [ -n "$TMUX" ]; then
  # tell tmux to pass the escape sequences through
  # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
  printf_template="${esc}Ptmux;${esc}${esc}]4;%d;rgb:%s\007${esc}\\"
  printf_template_var="${esc}Ptmux;${esc}${esc}]%d;rgb:%s\007${esc}\\"
  printf_template_custom="${esc}Ptmux;${esc}${esc}]%s%s\007${esc}\\"
elif [ "${TERM%%-*}" = "screen" ]; then
  # GNU screen (screen, screen-256color, screen-256color-bce)
  printf_template="${esc}P${esc}]4;%d;rgb:%s\007${esc}\\"
  printf_template_var="${esc}P${esc}]%d;rgb:%s\007${esc}\\"
  printf_template_custom="${esc}P${esc}]%s%s\007${esc}\\"
elif [[ $- != *i* ]]; then
  # non-interactive
  alias printf=/bin/false
else
  printf_template="${esc}]4;%d;rgb:%s${esc}\\"
  printf_template_var="${esc}]%d;rgb:%s${esc}\\"
  printf_template_custom="${esc}]%s%s${esc}\\"
fi

# 16 color space
printf $printf_template 0  $color00
printf $printf_template 1  $color01
printf $printf_template 2  $color02
printf $printf_template 3  $color03
printf $printf_template 4  $color04
printf $printf_template 5  $color05
printf $printf_template 6  $color06
printf $printf_template 7  $color07
printf $printf_template 8  $color08
printf $printf_template 9  $color09
printf $printf_template 10 $color10
printf $printf_template 11 $color11
printf $printf_template 12 $color12
printf $printf_template 13 $color13
printf $printf_template 14 $color14
printf $printf_template 15 $color15

# 256 color space
printf $printf_template 16 $color16
printf $printf_template 17 $color17
printf $printf_template 18 $color18
printf $printf_template 19 $color19
printf $printf_template 20 $color20
printf $printf_template 21 $color21

# foreground / background / cursor color
if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  whitecol="001c26"
  printf $printf_template_custom Pg ${color_foreground//\/} # forground
  printf $printf_template_custom Ph $whitecol               # background
  printf $printf_template_custom Pi ${color_foreground//\/} # bold color
  printf $printf_template_custom Pj ${color19//\/}          # selection color
  printf $printf_template_custom Pk ${color_foreground//\/} # selected text color
  printf $printf_template_custom Pl ${color_foreground//\/} # cursor
  printf $printf_template_custom Pm ${color_background//\/} # cursor text
else
  printf $printf_template_var 10 $color_foreground
  printf $printf_template_var 11 $color_background
  printf $printf_template_custom 12 ";7" # cursor (reverse video)
fi

# clean up
vars=$(grep -o '[0-9A-Z_a-z]\+=' "$BASH_SOURCE")
for v in $vars; do
  unset ${v%=}
done

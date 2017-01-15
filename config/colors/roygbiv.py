#!/usr/bin/env python
# coding: utf-8

def ctext(text, style=38, fg=5, bg=7):
    return """
{esc}
[{style};{fg};{bg}m{esc}
[{sty10};{fg};{bg}m{:s}
{esc}[39;49m
""".replace('\n', '').format(text, esc='\033',
    style=style, sty10=style+10, fg=fg, bg=bg)

for i in [0, 18, 19, 8, 20, 7, 21, 15, 9, 16, 3, 2, 6, 4, 5, 17]:
    text = 'color %03d ' % i

for i in range(256):
    print('%03d %s' % (i, ctext('=======', bg=i)))

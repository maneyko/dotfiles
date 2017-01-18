#!/usr/bin/env python
# coding: utf-8

def ctext(text, style=38, fg=5, bg=7):
    'Returns generic string of any style, foreground and background.'
    return """
{esc}
[{style};{fg};{bg}m{esc}
[{sty10};{fg};{bg}m{:s}
{esc}[39;49m
""".replace('\n', '').format(text, esc='\033',
    style=style, sty10=style+10, fg=fg, bg=bg)

def ptext(text, style=38, fg=5, bg=7):
    'Prints output of ``ctext``.'
    print(ctext(text, style=style, fg=fg, bg=bg))

for i in range(256):
    print('{:03d} {}'.format(i, ctext('=======', bg=i)))

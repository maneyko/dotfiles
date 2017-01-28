#!/usr/bin/env python

def ctext(n, text):
    return """
        {esc}
        [38;5;{bg}m{esc}
        [48;5;{bg}m{:s}
        {esc}[39;49m
    """.replace(' ', '').replace('\n', '').format(text, bg=n, esc='\033')

for i in range(256):
    print('{:03d} {}'.format(i, ctext(i, '=' * 7)))

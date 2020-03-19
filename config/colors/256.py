#!/usr/bin/env python3

def ctext(n, text):
    return """
        {esc}
        [38;5;{bg}m{esc}
        [48;5;{bg}m{:s}
        {esc}[39;49m
    """.replace(' ', '').replace('\n', '').format(text, bg=n, esc='\033')

for i in range(256):
    print(f' {i:03d} ', end='')
    print('{}'.format(ctext(i, '='*7)), end='')
    if (i+1) % 8 == 0:
        print()

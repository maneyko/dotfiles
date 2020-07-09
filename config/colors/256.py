#!/usr/bin/env python3

def ctext(n, text):
    return """
        {esc}
        [38;5;{bg}m{esc}
        [48;5;{bg}m{:s}
        {esc}[39;49m
    """.replace(' ', '').replace('\n', '').format(text, bg=n, esc='\033')

for i in range(32):
    for j in range(8):
        num = i + 32*j
        print(' {0:03d} '.format(num), end='')
        print('{}'.format(ctext(num, '='*7)), end='')
    print()

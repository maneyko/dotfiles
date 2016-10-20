#!/usr/bin/env python
# coding: utf-8

def ctext(n, text):
    return '{esc}[38;5;{:d}m{}{esc}[0m'.format(n, text, esc='\033')

for i in range(256):
    text = 'color %03d ' % i
    print(ctext(i, text + '■'*15))

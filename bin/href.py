#!/usr/bin/env python

import os
import sys
from argparse import ArgumentParser
if sys.version_info.major > 2:
    from html.parser import HTMLParser
    from urllib.request import urlopen
else:
    from HTMLParser import HTMLParser
    from urllib2 import urlopen

def parse_args():
    parser = ArgumentParser()
    parser.add_argument('url', help='link or html file')
    return parser.parse_args()

def html_contents(name):
    if os.access(name, os.R_OK):
        with open(name) as html_file:
            return html_file.read()
    if name[:4] != 'http':
        name = 'http://' + name
        return urlopen(name).read().decode('utf-8')

def handle_starttag(self, tag, attrs):
    'Overwrites HTMLParser.handle_starttag'
    if tag.lower() == 'a':
        self.hrefs.extend([a[1] for a in attrs if a[0].lower() == 'href'])

def get_hrefs(html_text):
    HTMLParser.handle_starttag = handle_starttag
    parser = HTMLParser()
    parser.hrefs = []
    parser.feed(html_text)
    return parser.hrefs

if __name__ == '__main__':
    args = parse_args()
    html_text = html_contents(args.url)
    hrefs = get_hrefs(html_text)
    for h in hrefs:
        print(h)

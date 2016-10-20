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
    try:
        html_text = urlopen(name).read().decode()
        return html_text
    except Exception as e:
        print('%s not a valid argument.' % name)
        print(e)
        sys.exit(1)

def handle_starttag(self, tag, attrs):
    if tag.lower() == 'a':
        hrefs = [ a[1] for a in attrs if a[0].lower() == 'href' ]
        for h in hrefs:
            self.hrefs.append(h)

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

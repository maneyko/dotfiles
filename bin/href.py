#!/usr/bin/env python
"""
Prints all values of ``href`` for ``<a>`` html tags from a link or html
file.
"""

import os
import argparse

from six.moves.html_parser import HTMLParser
from six.moves.urllib.request import urlopen


def parse_args(opts=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('url', help='link or html file')
    return parser.parse_args(opts)


def html_contents(path):
    """Returns HTML bytes of a link or file."""
    if os.access(path, os.R_OK):
        with open(path) as html_file:
            return html_file.read()
    if path[:4] != 'http':
        path = 'http://' + path
    return urlopen(path).read()


def get_hrefs(html_text):
    """Returns list of link paths from ``html_text``."""
    hrefs = []

    def handle_starttag(self, tag, attrs):
        if tag.lower() == 'a':
            hrefs.extend([a[1] for a in attrs
                          if a[0].lower() == 'href'])

    HTMLParser.handle_starttag = handle_starttag
    parser = HTMLParser()
    text = html_text.replace(b'\xa0', b' ').decode('utf-8')
    parser.feed(text)
    return hrefs


def main(args):
    by = html_contents(args.url)
    hrefs = get_hrefs(by)
    for href in hrefs:
        print(href)


if __name__ == '__main__':
    args = parse_args()
    main(args)

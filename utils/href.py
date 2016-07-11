#!/usr/bin/env python2

import os
from urllib2 import urlopen
import sys
from HTMLParser import HTMLParser

def handle_starttag(self, tag, attrs):
    if tag.lower() == 'a':
        hrefs = [ a[1] for a in attrs if a[0].lower() == 'href' ]
        for h in hrefs:
            self.hrefs.append(h)

def html_contents(name):
    if os.access(name, os.R_OK):
        return open(name).read()
    if name[:4] != 'http':
        name = 'http://' + name
    try:
        html_text = urlopen(name).read()
        return html_text
    except Exception as e:
        print name, 'not a valid argument.'
        print e
        sys.exit(1)

def usage():
    print """
    This script returns all 'href' links from a url or html file.
    Examples:
            {script} python.org
            {script} ./index.html
    """.format(script=script)
    sys.exit(0)

if __name__ == '__main__':
    script = sys.argv[0]
    if len(sys.argv) > 1:
        website = sys.argv[1]
    else:
        usage()
    if website in ['--help', '-h']:
        usage()
    html_text = html_contents(website)
    HTMLParser.handle_starttag = handle_starttag
    parser = HTMLParser()
    parser.hrefs = []
    parser.feed(html_text)
    for h in parser.hrefs:
        print h


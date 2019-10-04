#!/usr/bin/env python3

"""Merge PDF files."""

import os
import argparse
from PyPDF2 import PdfFileMerger


def parse_args(opts=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('pdfs', help='PDFs (in order) to merge', nargs='+')
    parser.add_argument('-o', '--output', default='merge-result.pdf',
        help='output PDF file (default: merge-result.pdf)')
    return parser.parse_args(opts)

def main(args):
    merger = PdfFileMerger()

    pdf_files = []

    for pdf in args.pdfs:
        pdf_files.append(open(pdf, 'rb'))
        merger.append(pdf_files[-1])

    with open(args.output, 'wb') as fout:
        merger.write(fout)

    for pdf in pdf_files:
        pdf.close()

if __name__ == '__main__':
    args = parse_args()
    main(args)


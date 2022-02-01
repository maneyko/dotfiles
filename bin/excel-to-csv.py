#!/usr/bin/env python

"""
Convert Excel file formats to CSV. May need to pip install 'xlrd' and 'openpyxl' first.
"""

from argparse import ArgumentParser, RawTextHelpFormatter

import pandas as pd

def parse_args(opts=None):
    parser = ArgumentParser(description=__doc__,
                            formatter_class=RawTextHelpFormatter)
    parser.add_argument('excel_file', help='Excel file to convert to CSV.')
    return parser.parse_args(opts)

def main(args):
    xls    = pd.ExcelFile(args.excel_file)
    no_ext = ".".join(args.excel_file.split(".")[0:-1])

    read_excel_args = {'header': None, 'keep_default_na': False, 'na_filter': False, 'dtype': str}
    write_csv_args  = {'header': False, 'index': False}

    if len(xls.sheet_names) <= 1:
        output_file = "%s.csv" % no_ext
        print("Writing to '%s'" % output_file)

        pd.read_excel(args.excel_file, **read_excel_args).to_csv(output_file, **write_csv_args)
    else:
        for sheet_name in xls.sheet_names:
            read_excel_args.update({'sheet_name': sheet_name})
            output_file = "%s.%s.csv" % (no_ext, sheet_name)
            print("Writing sheet '%s' to '%s'" % (sheet_name, output_file))
            pd.read_excel(args.excel_file, **read_excel_args).to_csv(output_file, **write_csv_args)

if __name__ == '__main__':
    args = parse_args()
    main(args)

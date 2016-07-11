#!/usr/bin/env python

import csv
import os
import sqlite3
from sys import argv

def usage():
    print("""
    Usage:
            {script} database.db

        =>  database/{{tables}}.csv
    """.format(script=script))
    exit(0)

def db2csv(con):
    cur = con.cursor()
    folder = os.path.splitext(db_name)[0].split('/')[-1]
    try:
        os.mkdir(folder)
    except OSError as e:
        print("Could not create directory '{folder}'".format(folder=folder))
        print("Exitting.")
        exit(1)
    os.chdir(folder)
    cur.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = [ t[0] for t in cur.fetchall() ]
    for table in tables:
        cur.execute("SELECT * FROM {table}".format(table=table))
        cols = [ c[0] for c in cur.description ]
        with open(table + '.csv', 'wb') as f:
            writer = csv.writer(f, lineterminator='\n')
            writer.writerow(cols)
            for row in cur:
                writer.writerow(row)

if __name__ == '__main__':
    script = argv[0]
    if len(argv) < 2:
        usage()
    if argv[1] in ['--help', '-h']:
        usage()
    db_name = argv[1]
    con = sqlite3.connect(db_name)
    db2csv(con)


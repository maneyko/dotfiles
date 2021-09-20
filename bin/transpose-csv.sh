#!/bin/bash

source "argparse.sh"

ARG_NUMBER_ROWS=1

arg_help       "[Transpose a CSV file. It kind of fudges up the last column though.]"
arg_boolean    "[pretty]      [p] [Pretty-print the result (if possible)]"
arg_optional   "[number-rows] [n] [Number of rows to transpose. Default '$ARG_NUMBER_ROWS']"
arg_positional "[file] [Input CSV file.]"
parse_args

if [[ -z $ARG_FILE ]]; then
  echo "$(cprint 1 ERROR): No input file specified. Use '-h' for usage."
  exit 1
fi

n=$(($ARG_NUMBER_ROWS + 1))

read -r -d '' python_script << EOT
import sys, io
import pandas as pd
df = pd.read_csv(io.StringIO(sys.stdin.read()), header=None, keep_default_na=False, na_filter=False, dtype=str)
if ("$ARG_PRETTY" == "true"):
    print(df.T.to_string(header=False, index=False))
else:
    df.T.to_csv('/dev/stdout', header=False, index=False)
EOT

python_command() {
  head -n$n "$ARG_FILE" | python -c "$python_script"
}

ruby_command() {
  head -n$n "$ARG_FILE" | ruby -rcsv -e 'puts CSV.parse(STDIN).transpose.map(&:to_csv)'
}

if [[ $(command -v ruby) && $n -le 1000 && -z $ARG_PRETTY ]]; then
  ruby_command
else
  python_command
fi

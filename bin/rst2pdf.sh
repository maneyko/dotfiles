#!/bin/bash

source "$(dirname "$0")/argparse.sh"

arg_positional "[file]       ['.rst' file to convert.]"
arg_boolean    "[delete] [d] [Delete the intermediate LaTeX file.]"
arg_help       "[Does a quick compilation of a '.rst' file to a '.pdf'.]"
parse_args

if [[ -n "$(command -v pdflatex)" ]]; then
  cat << EOT
'pdflatex' is not installed. On MacOS do: brew install mactex
EOT
  exit 1
fi

texfile="${ARG_FILE}.tex"

rst2latex.py "$ARG_FILE" "$texfile" || exit 1

pdflatex "$texfile"

[[ -n $ARG_DELETE ]] && rm "$texfile"
rm *.{aux,log,out}

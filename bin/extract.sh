#!/bin/bash

file="$1"

if [[ ! -f $file ]]; then
  echo "ERROR: '$file' is not a valid file."
  exit 1
fi

case "$file" in
  *.tar.*|*.tar|*.tbz2|*.tgz)
    tar xvf "$file" ;;
  *.gz)
    gunzip "$file" ;;
  *.bz2)
    bunzip=$(type -P bunzip bunzip2 | head -1)
    $bunzip "$file" ;;
  *.dmg)
    bunzip2 "$file" ;;
  *.zip|*ZIP)
    unzip "$file" ;;
  *.rar)
    unrar x "$file" ;;
  *.pax)
    cat "$file" | pax -r ;;
  *.Z)
    uncompress "$file" ;;
  *.7z)
    7z x "$file" ;;
  *.pax.Z)
    uncompress "$file" --stdout | pax -r ;;
  *) echo "'$file' cannot be extract via the extract command" ;;
esac

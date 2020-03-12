#!/bin/bash

f="$1"

if test -f "$f"; then
  case $f in
    *.tar.*|*.tar|*.tbz2|*.tgz)
      tar xvf "$f" ;;
    *.gz)
      gunzip "$f" ;;
    *.bz2)
      bunzip "$f" ;;
    *.dmg)
      bunzip2 "$f" ;;
    *.zip|*ZIP)
      unzip "$f" ;;
    *.rar)
      unrar x "$f" ;;
    *.pax)
      cat "$f" | pax -r ;;
    *.Z)
      uncompress "$f" ;;
    *.7z)
      7z x "$f" ;;
    *.pax.Z)
      uncompress "$f" --stdout | pax -r ;;
    *) echo "'$1' cannot be extract via the extract command" ;;
  esac
else
  echo "'$f' is not a valid file."
  exit 1
fi

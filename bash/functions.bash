# Bash Functions
# ==============

csview() {
  sed 's/,,/, ,/g; s/,,/, ,/g' "$@" | column -s, -t
}

csvhead() {
  head -n1 "$@" | tr ',' '\n'
}

goto() {
  mkdir -p "$@" && cd "$@"
}

jsonpp() {
  jq . < "$@"
}

sysbuild() {
  export PATH="\
/usr/local/bin:\
/usr/local/sbin:\
/usr/bin:\
/usr/sbin:\
/bin:\
/sbin:
"
  unalias -a
}

tarx() {
  if test -f "$1"
  then
    tar xvzf "$1"
  else
    echo "'$1' is not a valid file"
  fi
}

zipc() {
  if test -d "$1" -o -f "$1"
  then
    name=${1//\.*}
    zip -r "${name%/}.zip" "$1"
  else
    echo "$1" is not a valid file
  fi
}

office2pdf() {
  soffice --headless --convert-to pdf "$@"
}

man() {
  if which "$@" >/dev/null
  then
    vim -c "execute 'Man ' . '$@'" \
        -c "execute \"normal \<C-w>o\"" \
        -c "silent! call ReadMode(1)" \
        -c "set so=0 ft=man"
  else
    /usr/bin/env man "$@"
  fi
}

# Export all functions in this script
funcs=$(grep -o '[0-9A-Z_a-z]\+()' "$BASH_SOURCE")
for fn in $funcs; do
  export -f ${fn%()}
done

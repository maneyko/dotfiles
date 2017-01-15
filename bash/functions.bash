# functions
# ======================================================================

csview() {
  sed 's/,,/, ,/g; s/,,/, ,/g' $@ | column -s, -t
}

csvhead() {
  head -n1 "$@" | tr ',' '\n'
}

goto() {
  mkdir -p $@ && cd $@
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

if test $HOME = '/Users/maneyko'
then
  export is_maneyko='true'
else
  export is_maneyko=''
fi

man() {
  if which $@ >/dev/null
  then
    vim -c "execute 'Man ' . '$@'" \
        -c "execute \"normal \<C-w>o\"" \
        -c "silent! call ReadMode(1)" \
        -c "set so=0 ft=man"
  else
    /usr/bin/env man $@
  fi
}

extract() {
  if test -f "$1"
  then
    case "$1" in
      *.tar.*|*.tar|*.tbz2|*.tgz)
        echo "using tar"
        tar xf "$1"
        ;;
      *.gz)
        echo "using gunzip"
        gunzip "$1"
        ;;
      *.bz2)
        echo "using bunzip"
        bunzip2 "$1"
        ;;
      *.dmg)
        echo "using hdiutil"
        hdiutil mount "$1"
        ;;
      *.zip|*.ZIP)
        echo "using unzip"
        unzip -z "$1"
        ;;
      *.rar)
        echo "using unrar"
        unrar x "$1"
        ;;
      *.pax)
        echo "using pax"
        cat "$1" | pax -r
        ;;
      *.Z)
        echo "using uncompress"
        uncompress "$1"
        ;;
      *.pax.Z)
        uncompress "$1" --stdout | pax -r
        ;;
      *)
        echo "'$1' cannot be extracted/mounted"
        ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Export all functions in this script
funcs=$(grep -o '[a-zA-Z0-9]\+()' $BASH_SOURCE)
for fn in $funcs
do
  export -f ${fn//[()]}
done

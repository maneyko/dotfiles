#!/bin/bash

source "$(dirname "$0")/bin/argparse.sh"

FILES_TO_LINK=(
bash_profile
bashrc
inputrc
nvimrc
tmux.conf
vimrc
bin
config
ipython
vim
psqlrc
psqlrc.d
irbrc
)

files_help_format=""

for f in ${FILES_TO_LINK[@]}; do
  printf -v 'var' "%-30s => %s" "${0%/*}/$f" "\$HOME/.$f"
  files_help_format="$files_help_format\n    $var"
done

read -r -d '' helptext << EOT
Symlinks the following files in \$HOME/.dotfiles to \$HOME directory (with a '.' prepended):
$files_help_format

If the file already exists, a prompt will ask if you'd like to move it to dotfiles/_backups
EOT

arg_boolean "[uninstall] [u] [Uninstall maneyko's dotfiles]"
arg_boolean "[vim-full]  [f] [Install all vim plugins (~100Mb)]"
arg_help    "[\n$helptext]"
parse_args

cd "$HOME"

DOTFILES_FULL="$HOME/.dotfiles"

if [[ $__DIR__ != $DOTFILES_FULL && ! -d $DOTFILES_FULL ]]; then
  echo "$(cprint 3 INFO): Moving repo to \$HOME/.dotfiles"
  mv "$__DIR__" "$HOME/.dotfiles"
fi

for file_basename in "${FILES_TO_LINK[@]}"; do
  dotf=".$file_basename"
  if [[ -n $ARG_UNINSTALL ]]; then
    if [[ -e $dotf ]]; then
      if [[ -L $dotf ]]; then
        rm -v "$dotf"
      else
        echo "$(cprint 3 WARN): File '\$HOME/$dotf' is not a symlink! Won't remove it."
      fi
    fi
  fi
  if [[ -e $dotf ]]; then
    echo
    printf "~/$dotf exists, move to ~/.dotfiles/_backups/${file_basename}? [Y/n] "
    read res
    if [[ -z $res || $res = 'Y' || $res = 'y' ]]; then
      mkdir -p "$DOTFILES_FULL/_backups/"
      mv -v "$dotf" "$DOTFILES_FULL/_backups/$file_basename"
    else
      continue
    fi
  fi
  ln -vs ".dotfiles/$file_basename" "$dotf"
done

if [[ -n $ARG_UNINSTALL ]]; then
  # Check if directory is not empty
  if [[ -n "$(\ls "$DOTFILES_FULL/_backups" 2>/dev/null)" ]]; then
    cat << EOT

There is something in '$DOTFILES_FULL/_backups'
I will move it back to your \$HOME directory so you do not lose it.

EOT
    for f in $DOTFILES_FULL/_backups/*; do
      base="$(basename "$f")"
      dest="$HOME/.$base"
      if [[ -f $dest ]]; then
        echo "File '$dest' exists. Won't overwrite it."
        continue
      elif [[ -z "$(echo "${FILES_TO_LINK[@]}" | grep "^$base\$")" ]]; then
        echo "File '$dest' is not part of maneyko/dotfiles. Won't touch it."
        continue
      fi

      mv -v $DOTFILES_FULL/_backups/"$base" $HOME/."$base"
    done
  fi

  exit 0
fi

vim_path="$(type -P nvim vim vi | head -1)"
vim="$(basename $vim_path)"

if [[ $vim == nvim ]]; then
  vim_plug_dir="$HOME/.local/share/nvim/site"
  vim_config_dir="$HOME/.config/nvim"
else
  vim_plug_dir="$HOME/.vim"
  vim_config_dir="$HOME/.vim"
fi

curl -fLo "$vim_plug_dir/autoload/plug.vim" \
  --create-dirs \
    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if [[ -n $ARG_VIM_FULL && $vim == nvim ]]; then
  python3 -m pip install pynvim --upgrade
fi

if [[ -z $ARG_VIM_FULL ]]; then
  perl -i -pe 's/minimal_vimrc = ([\d]+)/minimal_vimrc = 1/g' $HOME/.dotfiles/vimrc
fi

$vim +PlugInstall +qall

if [[ $vim == nvim ]]; then
  $vim +UpdateRemotePlugins +qall
fi

rm -f "$vim_config_dir/plugged/vim-plug/.git/objects/pack/*.pack"  2>/dev/null

echo "$(cprint 2 OK)! Done."

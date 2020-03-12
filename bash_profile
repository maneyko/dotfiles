#!/bin/bash


if test -f $HOME/.bashrc -a -z "$COLORS"; then
  source $HOME/.bashrc
fi

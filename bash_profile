#!/bin/bash

test -n "$BASHRC_LOADED" && return

test -f $HOME/.bashrc && {
  source $HOME/.bashrc
}

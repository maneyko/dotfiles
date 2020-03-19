#!/bin/bash

test -z "$COLORS" && return

test -f $HOME/.bashrc && {
  source $HOME/.bashrc
}

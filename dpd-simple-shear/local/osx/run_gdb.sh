#!/bin/bash

. local/osx/vars.sh
. local/osx/utils.sh

lmp_dbg=$HOME/src/$lmp_dir/src/lmp_dbg
gdb_osx $lmp_dbg $vars -in in.dpd

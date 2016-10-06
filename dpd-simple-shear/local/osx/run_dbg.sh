#!/bin/bash

. local/osx/vars.sh
. local/osx/utils.sh

lmp_dbg=$HOME/src/$lmp_dir/src/lmp_dbg

mpirun -n $np lmp $vars -in in.pre
gdb_osx $lmp_dbg  $vars -in in.dpd

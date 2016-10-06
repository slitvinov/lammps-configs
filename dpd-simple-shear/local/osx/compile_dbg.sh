#!/bin/bash

# Compiles debug version of lammps source code
set -eu

. local/osx/vars.sh
. local/osx/utils.sh

cd $HOME/src/$lmp_dir/src

make_env+=" CCFLAGS=\"-g -O0\""

# emake is defined in utils.sh
#(cd .. && git clean -f -d -x)
emake clean-all
emake $lmp_pkg
emake $make_trg -j $make_np $make_env

safe_cp lmp_$make_trg $lmp_dbg

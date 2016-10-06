#!/bin/bash

# Compiles lammps source code
set -eu

. local/osx/vars.sh
. local/osx/utils.sh

cd $HOME/src/$lmp_dir/src

# emake is defined in utils.sh
(cd .. && git clean -f -d -x)
emake $lmp_pkg
emake $make_trg -j $make_np $make_env

safe_cp `pwd`/lmp_$make_trg $HOME/bin/lmp

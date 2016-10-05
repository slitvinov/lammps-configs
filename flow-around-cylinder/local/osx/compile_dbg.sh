#!/bin/bash

# Compiles debug version of lammps source code
set -eu

. local/osx/vars.sh
. local/osx/utils.sh

trg=mpi
make_np=4 # number of process to make

cd $HOME/src/$lmp_dir/src

make clean-all
make yes-RIGID
make $trg -j $make_np CCFLAGS="-g -O0"

safe_cp lmp_$trg $lmp_dbg

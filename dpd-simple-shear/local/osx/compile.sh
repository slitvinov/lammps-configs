#!/bin/bash

# Compiles lammps source code
set -eu

. local/osx/vars.sh
. local/osx/utils.sh

trg=mpi
make_np=4 # number of process to make

cd $HOME/src/$lmp_dir/src

make clean-all
make yes-RIGID
make $trg -j $make_np

safe_cp `pwd`/lmp_$trg $HOME/bin/lmp

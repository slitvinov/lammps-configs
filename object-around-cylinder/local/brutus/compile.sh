#!/bin/bash

. local/brutus/vars.sh

d=lammps-stokes
cd $HOME/src

#rm -rf $d
#git clone --depth 1 https://github.com/slitvinov/lammps-stokes.git

module load intel
module load open_mpi

cd $d/src

trg=ompi_icc
make yes-RIGID
make $trg -j 8

safe_ln `pwd`/lmp_$trg $HOME/bin/lmp

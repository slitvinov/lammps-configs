#!/bin/bash

. local/brutus/vars.sh
. local/brutus/utils.sh
. local/brutus/module.sh

d=lammps-stokes
cd $HOME/src

rm -rf $d
git clone --depth 1 https://github.com/slitvinov/lammps-stokes.git
cd $d/src

trg=ompi_icc
make yes-RIGID
make $trg -j 8

safe_ln `pwd`/lmp_$trg $HOME/bin/lmp

#!/bin/bash

# http://stackoverflow.com/a/6930607
# make the script fail on error
set -e
set -u

# the length of the swimmer
sw_length=100
# the nubmer of swimmers (see add.swimmer.position for definition of
# swimers' positions)
n_swimmer=1

# 0: bond_style harmonic/swimmer
# 1: bond_style harmonic/swimmer/extended
bond_extended=2

# generate grid
lmp=~/work/lammps-swimmer/src/lmp_linux
mpirun=~/prefix-mpich/bin/mpirun
#lmp=~/work/lammps-swimmer/src/lmp_linux
#mpirun=~/prefix-mpich/bin/mpirun

${lmp} -var sw_length ${sw_length} -in in.geninit

# create bonds for the swimmer
#awk -f ../scripts/template_eng.awk  ../scripts/addswimmer.awk > addswimmer.awk
awk -v n_swimmer=${n_swimmer} -v sw_length=${sw_length} -v bond_extended=${bond_extended} \
    -f addswimmer.awk data.grid > data.bond_nn

# count the number of bonds
awk -f count_bonds.awk data.bond_nn data.bond_nn > data.bond

# make all atoms of the swimmer of the type `new_type'
awk -v new_type=2 -f change_type_of_bonded.awk pass=1 data.bond pass=2 data.bond > data.polymer

${mpirun} -np 1 ${lmp} \
    -var sw_length ${sw_length} -in in.run

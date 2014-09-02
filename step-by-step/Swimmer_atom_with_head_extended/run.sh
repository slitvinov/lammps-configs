#!/bin/bash

# http://stackoverflow.com/a/6930607
# make the script fail on error
set -e
set -u

# the length of the swimmer
sw_length=30

lmp=~/Thesis/lammps-swimmer-transport-wip/src/lmp_linux
mpirun=~/prefix-mpi/bin/mpirun

# generate grid
${lmp} -var sw_length ${sw_length} -in in.geninit

# create bonds for the swimmer
awk -v sw_length=${sw_length} -f addswimmer.awk data.grid > data.bond_nn

# count the number of bonds
awk -f count_bonds.awk data.bond_nn data.bond_nn > data.bond

# make all atoms of the swimmer of the type `new_type'
awk -v new_type=2 -f change_type_of_bonded.awk  data.bond data.bond > data.polymer

${lmp} \
    -var sw_length ${sw_length} -in in.run

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

# the number of solvent "between" two polymers
Ns=15

# the number of beads in one polymer
Nb=10

# 0: bond_style harmonic/swimmer
# 1: bond_style harmonic/swimmer/extended
bond_extended=2

polymer_bond_type=1

atom_type_solvent=1
atom_type_polymer=2
atom_type_sw_rest=3
atom_type_sw_surface_head=4

# generate grid
lmp=~/work/lammps-swimmer/src/lmp_linux
mpirun=mpirun.mpich
#lmp=~/work/lammps-swimmer/src/lmp_linux
#mpirun=~/prefix-mpich/bin/mpirun

${lmp} -var sw_length ${sw_length} -in in.geninit

awk -f add_place_holder.awk data.grid > data.place_holder

# add polymer
awk -v polymer_candidate_type=${atom_type_solvent} -v polymer_bond_type=${polymer_bond_type} -v Nb=${Nb} -v Ns=${Ns} -v Np=1 \
    -f addpolymer.awk pass=1 data.place_holder pass=2 data.place_holder > data.polymer.ph

# renumber bonds
awk -f renumber_bonds.awk data.polymer.ph > data.polymer.renumberd

# count the number of bonds
awk -f count_bonds.awk pass=1 data.polymer.renumberd pass=2 data.polymer.renumberd > data.polymer.counted

# make all atomp of polymer a new type
awk -v new_type=${atom_type_polymer} -v bond_type_list=${polymer_bond_type} \
    -f change_type_of_bonded.awk pass=1 data.polymer.counted pass=2 data.polymer.counted > data.polymer

${mpirun} -np 1 ${lmp} \
    -var sw_length ${sw_length} -in in.run

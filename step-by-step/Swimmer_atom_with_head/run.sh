#!/bin/bash

# http://stackoverflow.com/a/6930607
# make the script fail on error
set -e
set -u

# the length of the swimmer
sw_length=20

# generate grid
./lmp_linux -var sw_length ${sw_length} -in in.geninit

# create bonds for the swimmer
awk -v sw_length=${sw_length} -f addswimmer.awk data.grid > data.bond_nn

# count the number of bonds
awk -f count_bonds.awk data.bond_nn data.bond_nn > data.bond

# make all atoms of the swimmer of the type `new_type'
awk -v new_type=2 -f change_type_of_bonded.awk  data.bond data.bond > data.polymer

n1_l1=$(awk 'NR==1{print $1}' swimmer.topology)
n2_l1=$(awk 'NR==1{print $2}' swimmer.topology)

n1_l2=$(awk 'NR==2{print $1}' swimmer.topology)
n2_l2=$(awk 'NR==2{print $2}' swimmer.topology)

~/prefix-mpi/bin/mpirun -np 4 ./lmp_linux  \
-var n1_l1 ${n1_l1} \
-var n2_l1 ${n2_l1} \
-var n1_l2 ${n1_l2} \
-var n2_l2 ${n2_l2} \
-var sw_length ${sw_length} -in in.run

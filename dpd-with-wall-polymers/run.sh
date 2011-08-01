#! /bin/bash

set -e
set -u

mpirun=/scratch/prefix-mpich/bin/mpirun
/scratch/work/lammps-ro/tools/chain2/src/chain2 -i in.generator -o chain.in -d def.chain  -echo both --verbose --extra-bond
${mpirun} -np 8 ../../src/lmp_linux -in in.fedosov

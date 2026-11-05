#! /bin/bash

set -e
set -u

mpirun=${MPIRUN:-mpirun}
lmp=${LMP:-lmp_mpi}
np=5

nbeads=$(awk '/monomers\/chain/{print $1}' def.chain)
bash ../scritps/mkchain.sh def.chain > chain.mol
${lmp} -var nbeads ${nbeads} -in in.generator

${mpirun} -np ${np} ${lmp} -in in.fedosov

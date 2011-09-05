#! /bin/bash

set -e
set -u

mpirun=mpirun
lmp=${HOME}/work/lammps-ro/src/lmp_linux
chain2=${HOME}/work/lammps-ro/tools/chain2/src/chain2
np=8

${chain2} -i in.generator -o chain.in -d def.chain  -echo both --verbose --extra-bond --keep-atoms
totnbeads=$(awk '/^need:/ {print $2}' log.generator)
nbeads=$(awk '/monomers\/chain/{print $1}' def.chain)
awk -v nbeads=${nbeads} -v totnbeads=${totnbeads} --lint=fatal \
    '/number of chains/{$1=int(totnbeads/nbeads)+1; print; next} 1' def.chain > def.chain.after

${chain2} -i in.generator -o chain.in -d def.chain.after  -echo both --verbose --extra-bond --keep-atoms
${mpirun} -np ${np} ${lmp} -in in.old

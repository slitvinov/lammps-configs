#! /bin/bash

set -e
set -u

Nb=$1
lmp=/scratch/work/lammps-ro/src/lmp_linux
restart2data=/scratch/work/lammps-ro/tools/restart2data
mpirun=/scratch/prefix-ppm-mpi/bin/mpirun

id=$(./genid.sh Nb=${Nb})
mkdir -p ${id}
vars="-var id ${id} -var ndim 2"

${lmp} ${vars} -in in.geninit
../scritps/addpolymer.sh \
    input=${id}/dpd.restart \
    polyidfile=${id}/poly.id \
    output=${id}/dpd.output \
    Nbeads=${Nb} \
    Nsolvent=0 \
    Npoly=full

${mpirun} -np 8  ${lmp} ${vars} -in in.main

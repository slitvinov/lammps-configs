#! /bin/bash

set -e
set -u

sigmaxy=$1
lmp=/scratch/work/lammps-ro/src/lmp_linux
restart2data=/scratch/work/lammps-ro/tools/restart2data
mpirun=/scratch/prefix-ppm-mpi/bin/mpirun

id=$(./genid.sh sigmaxy=${sigmaxy})
mkdir -p ${id}
vars="-var id ${id} \
    -var sigmaxy ${sigmaxy}"

${lmp} ${vars} -in in.geninit
../scritps/addpolymer.sh \
    input=${id}/dpd.restart \
    polyidfile=${id}/poly.id \
    output=${id}/dpd.output \
    Nbeads=1 \
    Nsolvent=1 \
    Npoly=full

${mpirun} -np 1  ${lmp} ${vars} -in in.dpd

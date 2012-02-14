#! /bin/bash

set -e
set -u

R=$1
lmp=/scratch/work/lammps-ro/src/lmp_linux
mpirun=/scratch/prefix-ppm-mpi/bin/mpirun

id=$(./genid.sh R=${R})
mkdir -p ${id}
vars="-var id ${id} \
    -var R ${R}"

${lmp} ${vars} -in in.geninit
../scritps/addpolymer.sh \
    input=${id}/dpd.restart \
    polyidfile=${id}/poly.id \
    output=${id}/dpd.output \
    Nbeads=15 \
    Nsolvent=15 \
    Npoly=full

${mpirun} -np 1  ${lmp} ${vars} -in in.dpd

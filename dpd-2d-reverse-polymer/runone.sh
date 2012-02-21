#! /bin/bash

set -e
set -u

R=$1
stfx=$2
Nb=15
lmp=/scratch/work/lammps-ro/src/lmp_linux
restart2data=/scratch/work/lammps-ro/tools/restart2data
mpirun=/scratch/prefix-ppm-mpi/bin/mpirun

id=$(./genid.sh R=${R} stfx=${stfx})

mkdir -p ${id}
vars="-var id ${id} -var ndim 2 -var R ${R} -var stfx ${stfx}"

${lmp} ${vars} -in in.geninit
../scritps/addpolymer.sh \
    input=${id}/dpd.restart \
    polyidfile=${id}/poly.id \
    output=${id}/dpd.output \
    Nbeads=${Nb} \
    Nsolvent=$((2*Nb)) \
    Npoly=full \
    addangle=0

${mpirun} -np 1  ${lmp} ${vars} -in in.main

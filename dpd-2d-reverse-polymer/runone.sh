#! /bin/bash

set -e
set -u

R=$1
stfx=$2
Nb=15

if [ -f ".lammps-configs" ]; then
    # try local configuration first
    source .lammps-configs
elif [ -f "${HOME}/.lammps-configs" ]; then
    # one for the host
    source ${HOME}/.lammps-configs
fi


id=$(./genid.sh R=${R} stfx=${stfx})

mkdir -p ${id}
vars="-var id ${id} -var ndim 2 -var R ${R} -var stfx ${stfx} -var dpdrandom ${RANDOM}"

${lmp} ${vars} -in in.geninit
../scritps/addpolymer.sh \
    input=${id}/dpd.restart \
    polyidfile=${id}/poly.id \
    output=${id}/dpd.output \
    Nbeads=${Nb} \
    Nsolvent=$((2*Nb)) \
    Npoly=full \
    addangle=0


${mpirun} -np 1  nice -n 19 ${lmp} ${vars} -in in.main


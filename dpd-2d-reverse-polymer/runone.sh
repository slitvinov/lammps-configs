#! /bin/bash

set -e
set -u

gx=$1
sx=$2
Nb=15

if [ -f ".lammps-configs" ]; then
    # try local configuration first
    source .lammps-configs
elif [ -f "${HOME}/.lammps-configs" ]; then
    # one for the host
    source ${HOME}/.lammps-configs
fi


id=$(./genid.sh gx=${gx} sx=${sx})

mkdir -p ${id}
vars="-var id ${id} -var ndim 2 -var gx ${gx} -var sx ${sx} -var dpdrandom ${RANDOM} -var Nb ${Nb}"

${lmp} ${vars} -in in.geninit
../scritps/addpolymer.sh \
    input=${id}/dpd.restart \
    polyidfile=${id}/poly.id \
    output=${id}/dpd.output \
    Nbeads=${Nb} \
    Nsolvent=$((2*Nb)) \
    Npoly=full \
    addangle=0

${mpirun} -np 8  nice -n 19 ${lmp} ${vars} -in in.main

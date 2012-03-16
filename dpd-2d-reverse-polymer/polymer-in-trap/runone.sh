#! /bin/bash

set -e
set -u

kst=$1
Nb=30

if [ -f ".lammps-configs" ]; then
    # try local configuration first
    source .lammps-configs
elif [ -f "${HOME}/.lammps-configs" ]; then
    # one for the host
    source ${HOME}/.lammps-configs
fi

id=trap/kst${kst}
mkdir -p ${id}
vars="-var id ${id} -var ndim 2  -var dpdrandom ${RANDOM} -var Nb ${Nb} -var kst ${kst}"

${lmp} ${vars} -in in.geninit
${lmpconfigdir}/scritps/addpolymer.sh \
    input=${id}/dpd.restart \
    polyidfile=${id}/poly.id \
    output=${id}/dpd.output \
    Nbeads=${Nb} \
    Nsolvent=1 \
    Npoly=1 \
    addangle=0

${mpirun} -np 1  nice -n 19 ${lmp} ${vars} -in in.main

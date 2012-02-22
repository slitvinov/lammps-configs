#! /bin/bash

set -e
set -u

gx=$1
Nb=15

if [ -f ".lammps-configs" ]; then
    # try local configuration first
    source .lammps-configs
elif [ -f "${HOME}/.lammps-configs" ]; then
    # one for the host
    source ${HOME}/.lammps-configs
fi


id=$(./genid.sh gx=${gx})

mkdir -p ${id}
vars="-var id ${id} -var ndim 2 -var gx ${gx} -var dpdrandom ${RANDOM}"

${lmp} ${vars} -in in.geninit
../scritps/addpolymer.sh \
    input=${id}/dpd.restart \
    polyidfile=${id}/poly.id \
    output=${id}/dpd.output \
    Nbeads=${Nb} \
    Nsolvent=$((2*Nb)) \
    Npoly=full \
    addangle=0

<<<<<<< HEAD
${mpirun} -np 1  nice -n 19 ${lmp} ${vars} -in in.main
=======
${mpirun} -np 8  ${lmp} ${vars} -in in.main
>>>>>>> 9c16eb91efcd5e89d663494843af111f586d3610

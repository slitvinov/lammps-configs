#! /bin/bash

set -e
set -u

gx=$1
Nb=80

if [ -f ".lammps-configs" ]; then
    # try local configuration first
    source .lammps-configs
elif [ -f "${HOME}/.lammps-configs" ]; then
    # one for the host
    source ${HOME}/.lammps-configs
fi
lmp=${lmp:-${LMP:-lmp_mpi}}
mpirun=${mpirun:-${MPIRUN:-mpirun}}


id=$(./genid.sh gx=${gx})

mkdir -p ${id}
vars="-var id ${id} -var ndim 3 -var gx ${gx} -var dpdrandom ${RANDOM} -var Nb ${Nb}"

${lmp} ${vars} -in in.geninit
st=$(awk '/^ *variable +simulationtype/{gsub(/"/, "", $4); print $4; exit}' in.generic)
addangle=0
if grep -q angle_style ${st}/in.* 2>/dev/null; then addangle=1; fi
periodic_y=1
if grep -q "boundary *p f" ${st}/in.* 2>/dev/null; then periodic_y=0; fi
../scritps/addpolymer.sh \
    input=${id}/dpd.restart \
    polyidfile=${id}/poly.id \
    output=${id}/dpd.output \
    Nbeads=${Nb} \
    Nsolvent=$((3*Nb)) \
    Npoly=full \
    addangle=${addangle} \
    periodic_y=${periodic_y}

${mpirun} -np 8  nice -n 19 ${lmp} ${vars} -in in.main

#! /bin/bash

set -e
set -u

R=$1
lmp=${LMP:-lmp_mpi}
mpirun=${MPIRUN:-mpirun}

id=$(./genid.sh R=${R})
mkdir -p ${id}
vars="-var id ${id} \
    -var R ${R}"

${lmp} ${vars} -in in.geninit
../scripts/addpolymer.sh \
    input=${id}/dpd.restart \
    polyidfile=${id}/poly.id \
    output=${id}/dpd.output \
    Nbeads=15 \
    Nsolvent=15 \
    Npoly=full

${mpirun} -np 1  ${lmp} ${vars} -in in.dpd

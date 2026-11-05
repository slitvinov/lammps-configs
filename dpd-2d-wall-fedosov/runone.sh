#! /bin/bash

set -e
set -u

sigmaxy=$1
lmp=${LMP:-lmp_mpi}
restart2data="${lmp} -restart2data"
mpirun=${MPIRUN:-mpirun}

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

#! /bin/bash

set -e
set -u

R=$1
lmp=${LMP:-lmp_mpi}
restart2data="${lmp} -restart2data"
mpirun=${MPIRUN:-mpirun}

id=$(./genid.sh R=${R})
mkdir -p ${id}
vars="-var id ${id} \
    -var R ${R}"

${lmp} ${vars} -in in.geninit
${restart2data} ${id}/dpd.restart ${id}/dpd.input
awk -v cutoff=3.0 -v Nbeads=15 -v Nsolvent=0 -v Npoly=full \
    -f addpolymer.awk ${id}/dpd.input > ${id}/dpd.output
nbound=$(tail -n 1 ${id}/dpd.output | awk '{print $1}')
sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" ${id}/dpd.output > ${id}/dpd.output.tmp && mv ${id}/dpd.output.tmp ${id}/dpd.output

${mpirun} -np 1  ${lmp} ${vars} -in in.dpd

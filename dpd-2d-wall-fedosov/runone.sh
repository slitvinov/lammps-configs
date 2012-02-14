#! /bin/bash

set -e
set -u

sigmaxy=$1
lmp=/scratch/work/lammps-ro/src/lmp_linux
restart2data=/scratch/work/lammps-ro/tools/restart2data
mpirun=/scratch/prefix-ppm-mpi/bin/mpirun

id=$(./genid.sh sigmaxy=${sigmaxy})
mkdir -p ${id}
vars="-var id ${id} \
    -var sigmaxy ${sigmaxy}"

${lmp} ${vars} -in in.geninit
${restart2data} ${id}/dpd.restart ${id}/dpd.input
awk -v cutoff=3.0 -v Nbeads=15 -v Nsolvent=0 -v Npoly=full \
    -f addpolymer.awk ${id}/dpd.input > ${id}/dpd.output
nbound=$(tail -n 1 ${id}/dpd.output | awk '{print $1}')
sed -i "s/_NUMBER_OF_BOUNDS_/$nbound/1" ${id}/dpd.output

${mpirun} -np 1  ${lmp} ${vars} -in in.dpd

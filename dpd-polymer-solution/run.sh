#! /bin/bash

set -e
set -u

lmp=${LMP:-lmp_mpi}
mpirun=${MPIRUN:-mpirun}
restart2data="${lmp} -restart2data"
# number of processors
np=1
awk_debug_flags=

function runsingle() {
    local Nbeads=$1
    ${lmp} -in in.geninit
    ${restart2data} dpd.restart dpd.input
    awk ${awk_debug_flags} -v cutoff=3.0 -v Nbeads=${Nbeads} -v Nsolvent=0 -v Npoly=full \
	-f addpolymer.awk dpd.input > dpd.input2
    nbound=$(tail -n 1 dpd.input2 | awk '{print $1}')
    sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" dpd.input2 > dpd.input
    ${mpirun} -n ${np} ${lmp} -v Nbeads ${Nbeads} -v dpdrandom ${RANDOM} -in in.main
}

nsl=10
runsingle 2 & sleep ${nsl}
runsingle 5 & sleep ${nsl}
runsingle 25 & sleep ${nsl}
runsingle 50

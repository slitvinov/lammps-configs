#! /bin/bash

set -e
set -u

source vars.sh
fwallx=$1

lmp=/scratch/work/lammps-ro/src/lmp_linux
ntime=${n1time}
id=$(getid)
${lmp} \
    -var fwallx ${fwallx} \
    -var id ${id} \
    -var ntime ${ntime} \
    -var ysize ${ysize} \
    -in in.dpd

ntime=${n2time}
id=$(getid)
${lmp} \
    -var fwallx ${fwallx} \
    -var id ${id} \
    -var ntime ${ntime} \
    -var ysize ${ysize} \
    -in in.dpd

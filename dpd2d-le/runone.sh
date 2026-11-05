#! /bin/bash

set -e
set -u

fwallx=$1
ntime=$2
lmp=${LMP:-lmp_mpi}
restart2data="${lmp} -restart2data"
savetime=$(./genid.sh list=savetime)

id=$(./genid.sh  fwallx=${fwallx} ntime=${ntime})
vars="-var fwallx ${fwallx} \
    -var id ${id} \
    -var ntime ${ntime} \
    -var savetime ${savetime}"


${lmp} ${vars} -in in.geninit
${restart2data} dpd.restart.${id} dpd.input.${id}
awk -v cutoff=3.0 -v Nbeads=5 -v Nsolvent=1 -v Npoly=full \
    -f addpolymer.awk dpd.input.${id} > dpd.output.${id}
nbound=$(tail -n 1 dpd.output.${id} | awk '{print $1}')
sed "s/_NUMBER_OF_BOUNDS_/$nbound/1" dpd.output.${id} > dpd.output.${id}.tmp && mv dpd.output.${id}.tmp dpd.output.${id}

${lmp} ${vars} -in in.dpd

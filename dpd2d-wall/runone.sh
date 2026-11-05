#! /bin/bash

set -e
set -u

fwallx=$1
ntime=$2
lmp=${LMP:-lmp_mpi}
savetime=$(./genid.sh list=savetime)

id=$(./genid.sh  fwallx=${fwallx} ntime=${ntime})
${lmp} \
    -var fwallx ${fwallx} \
    -var id ${id} \
    -var ntime ${ntime} \
    -var savetime ${savetime} \
    -in in.dpd




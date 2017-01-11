#!/bin/bash

set -eux

. local/osx/vars.sh
. local/osx/utils.sh

#mpirun -n $np lmp $vars -in in.pre
lmp $vars -in in.pre
rx=$rx ry=$ry type=$solid_type ./scripts/elliptic_cylinder.awk pre/pre.data.out > pre/pre.data.in

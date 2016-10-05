#!/bin/bash

. local/brutus/vars.sh
. local/brutus/utils.sh
. local/brutus/module.sh

vars+=" -var sc  ${sc}"
vars+=" -var gx0 ${gx0} "
vars+=" -var nd  ${nd} "

bsub -K -W 00:10  -n 4 mpirun lmp $vars -in in.pre

scripts/parse0.awk -v xc=$xc -v sc=$sc pre/pre.data.out > pre/pre.data.in
bsub    -W $wtime -n $np mpirun lmp $vars -in in.dpd

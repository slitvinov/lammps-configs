#!/bin/bash

. local/brutus/vars.sh
. local/brutus/utils.sh
. local/brutus/module.sh

bsub -K -W 00:10  -n 8 mpirun lmp -in in.pre
scripts/parse3d.awk pre/pre.data.out > pre/pre.data.in

bsub    -W $wtime -n $np mpirun lmp -in in.dpd

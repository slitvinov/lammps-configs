#! /bin/bash

awk '/TIMESTEP/{if (flag) {printf "\n"}; flag=0} flag{print $3, $4, $2} /ITEM: ATOMS/{flag=1}' \
    dump.dpd.*.$(./genid.sh s=".dat" ntime=80000 fwallx=1e-2) > punto.dat


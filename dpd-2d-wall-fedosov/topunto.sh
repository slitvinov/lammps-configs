#! /bin/bash

n1time=$(./genid.sh  list=ntime | awk 'NR==1')
n2time=$(./genid.sh  list=ntime | awk 'NR==2')

for fx in $(./genid.sh  list=fwallx); do
    awk '/TIMESTEP/{if (flag) {printf "\n"}; flag=0} flag{print $3, $4, $6, $7} /ITEM: ATOMS/{flag=1}' \
	dump.dpd.*.$(./genid.sh s=".dat" ntime=${n1time} fwallx=${fx}) > punto.dat.${fx}
done

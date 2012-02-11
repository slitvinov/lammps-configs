#! /bin/bash

set -e
set u
source vars.sh
for fwallx in ${fxlist} ; do
    a=$(./fitvx.sh vy.av.$(ntime=${n2time} getid).dat vy.av.$(ntime=${n1time} getid).dat  gp${fwallx})
    echo ${fwallx} ${a}
done


# function post-solvent() {
#     for file in $(ls -1 dump.dpd.* | sort -k 3 -t . -g); do
# 	printf "file: %s\n" $file > "/dev/stderr"
# 	awk 'flag{print $3, $4, $2} /ITEM: ATOMS/{flag=1}' $file
# 	printf "\n"
#     done > punto.dat
# }

# post-solvent


	

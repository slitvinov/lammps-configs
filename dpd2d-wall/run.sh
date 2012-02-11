#! /bin/bash

set -e
set -u
for ntime in $(./genid.sh  list=ntime); do
    for fx in $(./genid.sh  list=fwallx); do
	echo $fx 
	echo ${ntime}
    done 
done| ~/bin/parallel -N2 -j 8 --verbose ./runone.sh {1} {2}

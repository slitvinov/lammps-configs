#! /bin/bash

set -e
set -u

for R in $(./genid.sh  list=R); do
for stfx in $(./genid.sh  list=stfx); do
	echo ${R}
	echo ${stfx}
done
done | ~/bin/parallel -N2 --verbose ./runone.sh {1} {2}

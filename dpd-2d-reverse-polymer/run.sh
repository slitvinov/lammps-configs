#! /bin/bash

set -e
set -u

for gx in $(./genid.sh  list=gx); do
	echo ${gx}
done | ~/bin/parallel -N1 -j 8 --verbose ./runone.sh {1}

#! /bin/bash

set -e
set -u

for gx in $(./genid.sh  list=gx); do
	echo ${gx}
done| parallel -j 1 -N1 --verbose ./runone.sh {1}

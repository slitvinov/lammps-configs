#! /bin/bash

set -e
set -u

for gx in $(./genid.sh  list=gx); do
    for sx in $(./genid.sh  list=sx); do
	echo ${gx}
	echo ${sx}
    done 
done| parallel -j 1 -N2 --verbose ./runone.sh {1} {2}

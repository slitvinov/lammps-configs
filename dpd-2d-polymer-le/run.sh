#! /bin/bash

set -e
set -u
for R in $(./genid.sh  list=R); do
	echo ${R}
done| parallel -N1 -j 8 --verbose ./runone.sh {1}

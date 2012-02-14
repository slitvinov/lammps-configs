#! /bin/bash

set -e
set -u
for sigmaxy in $(./genid.sh  list=sigmaxy); do
	echo ${sigmaxy}
done| ~/bin/parallel -N1 -j 8 --verbose ./runone.sh {1}

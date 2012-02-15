#! /bin/bash

set -e
set -u

varname=$(./genid.sh varlist=1)
for val in $(./genid.sh  list=${varname}); do
	echo ${val}
done | ~/bin/parallel -N1 -j 8 --verbose ./runone.sh {1}

#! /bin/bash

set -e
set -u



for gx in $(./genid.sh  list=gx); do
	echo ${gx}
done | parallel -N1 --verbose ./runone.sh {1}

#! /bin/bash

set -e
set -u
source vars.sh
for fx in ${fxlist} ; do
    echo $fx
done | ~/bin/parallel -N1 -j 8 --verbose ./runone.sh {}

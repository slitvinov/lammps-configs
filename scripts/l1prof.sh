#! /bin/bash

set -e
set -u
dname=$1
ymin=0.1
ymax=0.9

thisfile=${dname}/vx.x0.905
for nextfile in ${dname}/vx.x*; do
    nname=$(basename ${nextfile})
    pos=$(echo ${nname} | sed 's/vx.x//g')
    pdiff=$(paste $thisfile $nextfile | awk -v ymin=$ymin -v ymax=$ymax '$1>ymin&&$1<ymax{s += ($2 - $4)^2; n++} END {print sqrt(s/n)}')
    echo ${pos} ${pdiff}
done > ${dname}/l1.dat

#! /bin/bash

set -e
set -u

for R in $(./genid.sh p=solvent list=R); do
    id=$(./genid.sh R=${R})
    sigma=$(./fitvx.sh ${id}/sxy.av ${id}/sigma | awk '{print $2}')
    psigma=$(./fitvx.sh ${id}/sxy-bond.av ${id}/sigma | awk '{print $2}')
    echo ${R} ${sigma} ${psigma}
done > gamma.dat

gnuplot <<EOF
set log
set term dumb
plot "gamma.dat" u 1:(\$2/\$1) w lp
call "saver.gp" "gamma"
EOF

	

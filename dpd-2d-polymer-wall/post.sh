#! /bin/bash

set -e
set -u

for sigmaxy in $(./genid.sh p=solvent list=sigmaxy); do
    id=$(./genid.sh sigmaxy=${sigmaxy})
    gamma=$(./fitvx.sh ${id}/vx.av ${id}/vx "" | awk '{print $1}')
    sigmasim=$(./fitvx.sh ${id}/sxy.av ${id}/sigma "[4:18]" | awk '{print $2}')
    echo ${gamma} ${sigmaxy} ${sigmasim}
done > gamma.dat

gnuplot <<EOF
set log
set term dumb
plot "gamma.dat" u 1:(\$2/\$1) w lp
call "saver.gp" "gamma"
EOF

	

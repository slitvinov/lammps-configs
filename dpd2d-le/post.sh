#! /bin/bash

set -e
set u
n1time=$(./genid.sh  list=ntime | awk 'NR==1')
n2time=$(./genid.sh  list=ntime | awk 'NR==2')

for fwallx in $(./genid.sh  list=fwallx); do
    a=$(./fitvx.sh $(./genid.sh p=vx.av.id ntime=${n1time} fwallx=${fwallx})  $(./genid.sh p=vx.av.id ntime=${n2time} fwallx=${fwallx}) gp${fwallx})
    echo ${fwallx} ${a}
done > gamma.dat

gnuplot <<EOF
set log
plot "gamma.dat" u 1:(\$2/\$1) w lp
call "saver.gp" "gamma"
EOF


# function post-solvent() {
#     for file in $(ls -1 dump.dpd.* | sort -k 3 -t . -g); do
# 	printf "file: %s\n" $file > "/dev/stderr"
# 	awk 'flag{print $3, $4, $2} /ITEM: ATOMS/{flag=1}' $file
# 	printf "\n"
#     done > punto.dat
# }

# post-solvent


	

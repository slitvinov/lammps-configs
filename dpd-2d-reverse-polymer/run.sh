#! /bin/bash

set -e
set -u

<<<<<<< HEAD
for R in $(./genid.sh  list=R); do
for stfx in $(./genid.sh  list=stfx); do
	echo ${R}
	echo ${stfx}
done
done | ~/bin/parallel -N2 --verbose ./runone.sh {1} {2}
=======
for gx in $(./genid.sh  list=gx); do
	echo ${gx}
done | ~/bin/parallel -N1 -j 8 --verbose ./runone.sh {1}
>>>>>>> 9c16eb91efcd5e89d663494843af111f586d3610

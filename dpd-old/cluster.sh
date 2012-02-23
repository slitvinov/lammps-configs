#!/bin/bash 
#$-o $HOME/hello.$JOB_ID.out -j y
#$-N test
#$-S /bin/bash 
#$-M sergej.litvinov@aer.mw.tum.de
#$-l h_rt=00:20:00
#$-l march=x86_64
#$-pe mpi_8 8

cd ${HOME}/work/lammps-ro/lammps-configs/dpd-old
bash runcluster.sh

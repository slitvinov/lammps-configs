#!/bin/bash
#PBS -M sergej.litvinov@aer.mw.tum.de
#PBS -j oe
#PBS -o /home/hlrb2/pr95zi/lu79buz3/hlrb-test.out
#PBS -o /home/hlrb2/pr95zi/lu79buz3/hlrb-test.err
#PBS -l select=8:ncpus=1:mem=2000mb
#PBS -l walltime=00:20:00
#PBS -N test-fftw

. /etc/profile.d/modules.sh
module unload mpi.altix
module load mpi.intel

cd ${HOME}/work/lammps-ro/lammps-configs/dpd-old
bash runhlrb.sh

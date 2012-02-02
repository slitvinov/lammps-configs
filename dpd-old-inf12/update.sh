#! /bin/bash

gnuplot vel.gp
cp vel.png ~/Dropbox/Public/dpd/

cd /scratch/work/lammps-ro/lammps-configs/dpd-old/
gnuplot vel.gp
cp vel.png ~/Dropbox/Public/dpd/vel-inf.png
cp stress.png ~/Dropbox/Public/dpd/stress-inf.png

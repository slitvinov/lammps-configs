#! /bin/bash

cd /scratch/work/lammps-ro/lammps-configs/dpd-resonance/
rsync -avz -r --exclude 'dump.dpd3*' litvinov@fujie:/scratch/litvinov/lammps-ro/lammps-configs/dpd-resonance/k*a25.0* .

rsync -avz -r --exclude 'dump.dpd3*' litvinov@misato:/scratch/litvinov/lammps-ro/lammps-configs/dpd-resonance/k*a75.0T* .



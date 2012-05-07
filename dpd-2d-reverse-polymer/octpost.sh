#! /bin/bash

for dname in $(ls -d st-relax-nb80-sx50~g~*); do
    octave --no-window-system -qf /home/litvinov/google-svn/octave/matdcd-scripts/post-lammps.m  ${dname}/data.dcd
    mv data ${dname}
    awk '{print $1}' ${dname}/data/end2end.dat > ${dname}/data/end2endX.dat
done

#!/bin/bash

. local/brutus/vars.sh

(
    cd ../..
    ln -s lammps-configs/object-around-cylinder/ppm.gnfluid .
    ln -s lammps-configs/object-around-cylinder/fluid       .
)

#! /bin/bash

# generate grid in lammps
../../../../src/lmp_linux -in in.grid

# create a data file
../../../../tools/restart2data grid.restart grid.data

# read data file in vmd
vmd -dispdev text -e polyongrid.tcl
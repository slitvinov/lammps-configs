#! /bin/bash

# write lammps data file data.step1a
vmd -dispdev text -e simplexyztodata.tcl

# visualize 
#vmd -e viz.tcl


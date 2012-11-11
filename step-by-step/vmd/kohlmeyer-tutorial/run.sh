#! /bin/bash

# write lammps data file data.step1a
vmd -dispdev text -e twotypesxyztodata.tcl

# visualize 
vmd -e viz.tcl


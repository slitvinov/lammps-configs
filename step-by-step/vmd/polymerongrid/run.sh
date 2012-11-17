#! /bin/bash

../../../../src/lmp_linux -in in.grid

../../../../tools/restart2data grid.restart grid.data

vmd -dispdev text -e polyongrid.tcl
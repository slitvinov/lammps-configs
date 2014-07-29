#!/bin/bash

# http://stackoverflow.com/a/6930607
# make the script fail on error
set -e
set -u

# the number of bonds: Nb
# the number of aggles: Na (for a linear chain Nb-1)

Nb=5
Na=4 # define Na= Nb-1

./lmp_linux -var Nb ${Nb} -var Na ${Na}   -in in.geninit
awk -v Nb=${Nb} -v Na=${Na} -f addpolymer.awk data.grid > data.polymer

./lmp_linux -var Nb ${Nb} -in in.run

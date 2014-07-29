#!/bin/bash

# the number of bonds: Nb
#Na= Number of Angles

Nb=5
Na=4 # define Na= Nb-1

./lmp_linux -var Nb ${Nb} Na ${Na}   -in in.geninit
awk -v Nb=${Nb} -v Na=${Na} -f addpolymer.awk data.grid > data.polymer

./lmp_linux -in in.run

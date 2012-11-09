#! /bin/bash

../../../../src/lmp_linux -in in.polymer 

# generate psf file with vmd
vmd -dispdev text -eofexit <<EOF
package require topotools
topo readlammpsdata polymer.data
animate write psf polymer.psf
EOF
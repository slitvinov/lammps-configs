#! /bin/bash

set -u
set -e

../../../src/lmp_linux -in in.create
../../../tools/restart2data data.restart  solvent.data
 
PYTHONPATH=${HOME}/work/Pizza.py/src python2.7 createpolymers.py \
    --input solvent.data --output polymer.data --Nb 20 --Ns 20 --Np 1000

input=polymer.data
output=polymer.psf
vmd -dispdev text -eofexit <<EOF
package require topotools
topo readlammpsdata  ${input} bond
animate write psf ${output}
EOF

../../../src/lmp_linux -in in.run


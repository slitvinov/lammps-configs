#! /bin/bash

set -u
set -e

../../../src/lmp_linux -in in.create
../../../tools/restart2data data.restart  solvent.data
 
PYTHONPATH=${HOME}/work/Pizza.py/src python2.7 createpolymers.py \
    --input solvent.data --output polymer.data --Nb 1 --Ns 0 --Np full

input=polymer.data
output=polymer.psf
vmd -dispdev text -eofexit <<EOF
package require topotools
topo readlammpsdata  ${input} angle
animate write psf ${output}
EOF

../../../src/lmp_linux -in in.run


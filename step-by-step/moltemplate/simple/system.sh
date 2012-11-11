#! /bin/bash

moltemplate.sh system.lt

# generate psf file with vmd
vmd -dispdev text -eofexit <<EOF
package require topotools
topo readlammpsdata system.data
animate write psf system.psf
EOF
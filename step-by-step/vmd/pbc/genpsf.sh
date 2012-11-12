#! /bin/bash


# generate psf file with vmd
vmd -dispdev text -eofexit <<EOF
package require topotools
topo readlammpsdata data.pcb angle
animate write psf data.psf
EOF
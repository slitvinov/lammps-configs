#! /bin/bash

# generate psf file with vmd
vmd -dispdev text -eofexit <<EOF
package require topotools
topo readlammpsdata poly-mod.txt angle
set sel [atomselect top all]
$sel set name A
animate write psf poly3d.psf
EOF

awk 'NF==7{$3="A"; $4="A"; $0="         "$0} 1' poly3d.psf > poly-mod.psf
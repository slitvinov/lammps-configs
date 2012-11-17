# vmd -psf poly3d.psf  -dcd /scratch2/work/lammps-sph/examples/USER/sph/sdpd-polymer-fedosov/poly3d.dcd  -e makemol.tcl
log ~/vmd.tcl

set sel [atomselect top "resname 1"]
$sel set name A

set sel [atomselect top "resname 2"]
$sel set name B

set sel [atomselect top "resname 4"]
$sel set name C

pbc box
pbc join connected -all  -verbose
color Display Background white

mol color Name
mol representation Lines 2.0

mol selection name B
mol material Opaque
mol addrep 0
mol modselect 1 0 name C
mol modstyle 1 0 Points 20


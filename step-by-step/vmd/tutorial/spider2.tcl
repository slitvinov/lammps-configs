# vmd -psf poly3d.psf  -dcd /scratch2/work/lammps-sph/examples/USER/sph/sdpd-polymer-fedosov/poly3d.dcd  -e makemol.tcl
log ~/vmd.tcl

# to supress output
proc @ {} {
    concat
}

set sel_solvent [atomselect top "resname 1"]
$sel_solvent set name solvent

set sel_polymer [atomselect top "resname 2"]
$sel_polymer set name polymer

set sel_wall [atomselect top "resname 4"]
$sel_wall set name wall


# boundary conditions
pbc box

# domain size from lammps configuration file
set Lx 4.9999998000000001e-01
set Ly 5.3333331200000000e-02
set Lz 5.3333331200000000e-02

# dx for particle placing
set dx 8.333333e-4

set xmin [expr 3*${dx}]
set xmax [expr $Lx-3*${dx}]

set ymin [expr 3*${dx}]
set ymax [expr $Ly-3*${dx}]

set zmin [expr 3*${dx}]
set zmax [expr $Lz-3*${dx}]

proc makeS {sstring} {
    [atomselect top "name S"] set name polymer
    set small [atomselect top ${sstring}]
    $small set name S
}

set sstring "x>${xmin} and x<${xmax} and y>${ymin} and y<${ymax} and z>${zmin} and z<${zmax} and name polymer"

user add key n {animate next; makeS $sstring}
user add key p {animate prev; makeS $sstring}

mol modselect 0 0 name S
source position2.tcl

# set blist [$sel_polymer getbonds]; @
# interp recursionlimit {} 100000
# set bstructure [::PBCTools::get_connected $blist]; @

color Display Background white
color Name S blue
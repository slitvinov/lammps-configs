# vmd -psf poly3d.psf  -dcd /scratch2/work/lammps-sph/examples/USER/sph/sdpd-polymer-fedosov/poly3d.dcd  -e makemol.tcl
log ~/vmd.tcl
set sel [atomselect top all]
$sel set name A
$sel set radius 5e-6

# to supress output
proc @ {} {
    concat
}

# get a list of all bounds
set blist [$sel getbonds]; @

# create a structure with connected atoms
set bstructure [::PBCTools::get_connected $blist]; @

# change molecula IDs for connected atoms
set n [llength ${bstructure}]
for {set i 0} {$i < $n} {incr i} {
    vmdcon -info "Processing polymer number: " $i "out of " $n
    set bchain [lindex ${bstructure} $i]
    set selchain [atomselect top [join "index ${bchain}"]]
    $selchain set name $i
}

pbc box
pbc join connected -now  -verbose
color Display Background white
color Axes Labels blue
mol modstyle 0 0 Lines 2.5

source position.tcl
#render Tachyon vmdscene.dat "/scratch/netbsd/lib/vmd/tachyon_LINUXAMD64" -aasamples 12 %s -format TARGA -o %s.tga
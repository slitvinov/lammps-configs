#!/usr/bin/tclsh

# topotools example 1d:
# generate topology data from coordinate data
# for a spiral chain of model particles.
##############################################

# explicitly load topotools and pbctools packages since
# they are not automatically requred in text mode and
# abort if their version numbers are insufficient.
if {[catch {package require topotools 1.1} ver]} {
   vmdcon -error "$ver. This script requires at least TopoTools v1.1. Exiting..."
   quit
}
if {[catch {package require pbctools 2.3} ver]} {
   vmdcon -error "$ver. This script requires at least pbctools v2.3. Exiting..."
   quit
}
# check for presence of coordinate file
set fname spiral.xyz
if {! [file exists $fname]} {
   vmdcon -error "Required file '$fname' not available. Exiting..."
   quit
}
# load coordinates but don't automatically compute bonds
mol new $fname autobonds no waitfor all

# set atom name/type and radius for all atoms
set sel [atomselect top all]
$sel set radius 0.85
$sel set name A
$sel set type A
$sel set mass 1.0

# automatic bond generation doesn't work for this.
# but we know that the input is just one long chain
# of connected atoms. so we can generate the bondlist
# through a simple loop over atom indices. we also
# define bondtypes in one swoop.
set blist {}
set natoms [molinfo top get numatoms]
for {set a 0; set b 1} {$b < $natoms} {incr a; incr b} {
  # each bond list entry is: <idx> <idx> [<type>] [<order>]
  lappend blist [list $a $b A-A 1]
}
topo setbondlist both $blist
vmdcon -info "assigned [topo numbondtypes] bond types to [topo numbonds] bonds:"
vmdcon -info "bondtypes: [topo bondtypenames]"


# now derive angle definitions from bond topology.
# every two bonds that share an atom yield an angle.
topo guessangles
vmdcon -info "assigned [topo numangletypes] angle types to [topo numangles] angles:"
vmdcon -info "angletypes: [topo angletypenames]"

# now let VMD reanalyze the molecular structure
# this is needed to detect fragments/molecules
# after we have recomputed the bonds
mol reanalyze top

# now set box dimensions and write out the result as 
# a lammps data file.
pbc set {100.0 100.0 100.0 90.0 90.0 90.0}
topo writelammpsdata data.step1d angle

# also write out a .psf for visualization
animate write psf spiral.psf

# done. now exit vmd
quit

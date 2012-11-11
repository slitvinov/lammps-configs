#!/usr/bin/tclsh

# topotools example 1c:
# generate topology data from coordinate data
# for a simple linear chain of model particles.
##############################################

# explicitly load topotools and pbctools packages since
# they are not automatically requred in text mode and
# abort if their version numbers are insufficient.
if {[catch {package require topotools 1.2} ver]} {
   vmdcon -error "$ver. This script requires at least TopoTools v1.2. Exiting..."
   quit
}
if {[catch {package require pbctools 2.3} ver]} {
   vmdcon -error "$ver. This script requires at least pbctools v2.3. Exiting..."
   quit
}
# check for presence of coordinate file
if {! [file exists chain.xyz]} {
   vmdcon -error "Required file 'chain.xyz' not available. Exiting..."
   quit
}

# load coordinates but don't automatically compute bonds
mol new chain.xyz autobonds no waitfor all

# set atom name/type and radius for all atoms
set sel1 [atomselect top all]
$sel1 set radius 0.85
$sel1 set name A
$sel1 set type A
$sel1 set mass 1.0

# now create a new, empty molecule to hold 
# the data for the full resulting topology

# we make room for 2 molecules
set natoms1 [molinfo top get numatoms]
set natoms2 [expr {$natoms1 * 2}]
mol new atoms $natoms2

# the new molecule has no coordinate data storage,
# this will create one with all coordinates set to 0.0
animate dup top

# collect atomic info for original data
set proplist {name type radius resname mass x y z}
set atomdata1 [$sel1 get $proplist]

# now translate molecule 1 by -15 angstrom in z
$sel1 moveby {4.0 0.0 0.0}
# and make other modifications, if desired, e.g.:
# $sel1 set name B
# $sel1 set type B
# $sel1 set resname CHB
set atomdata2 [$sel1 get $proplist]

# combine the data and assign to the new molecule.
set sel2 [atomselect top all]
set atomdata [concat $atomdata1 $atomdata2]
$sel2 set $proplist $atomdata

# bonds are computed based on distance criterion
# bond if 0.6 * (r_A + r_B) > r_AB.
# with radius 0.85 the cutoff is 1.02
# the example system has particles 1.0 apart.
mol bondsrecalc top

# now recompute bond types. 
# by default a string label: <atom type 1>-<atom type 2>
# we have all atoms of type A, so there should be only 
# one bond type, A-A
topo retypebonds 
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
topo writelammpsdata data.step1c angle

# done. now exit vmd
quit

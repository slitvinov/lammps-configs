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

set natoms1 [molinfo top get numatoms]
set k       2


set natoms_tot [expr {$natoms1 * $k}]
mol new atoms $natoms_tot
animate dup top
set proplist {name type radius resname mass x y z}
set atomdata1 [$sel1 get $proplist]

for {set i 1} {$i < $k} {incr i} {
    # make room for all chains
    $sel1 moveby {4.0 0.0 0.0}
    set atomdata2 [$sel1 get $proplist]
    set sel2 [atomselect top all]
    set atomdata [concat $atomdata1 $atomdata2]
    $sel2 set $proplist $atomdata
    vmdcon -info "preved" $i
}


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

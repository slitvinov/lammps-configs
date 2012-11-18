# Run with
# vmd -dispdev text -psf data.psf -dcd data.dcd -e selection.tcl
# To use vmd in emacs as a tcl shell
# C-u run-tcl ./r.sh
log ~/vmd.tcl

set sel [atomselect top all]
# number of atoms in the selection
$sel num

# list of indexes
$sel list

# show frame frame
$sel frame

# set frame for the selection
$sel frame now

# and show it
$sel frame

# return attributes
# get a list of all possible attributes
atomselect keywords
puts "======attributes===="
# x y z vx vy vz
# chain
set zlist [$sel get y]
# firs element in a list
lindex ${zlist} 1
puts "======attributes===="

# set attributes
$sel set x 10
$sel set y 10

# - getbonds: returns a list of bondlists; each bondlist contains the
#   id's of the atoms bonded to the corresponding atom in the selection.
# - setbonds: Set the bonds for the atoms in the selection; the second
#   argument should be a list of bondlists, one bondlist for each
#   selected atom.
puts "======bonds===="
set blist [$sel getbonds]

# atom with index 0 is bonded to atom 1
lindex ${blist} 0

# atom with index 1 is bonded to atoms 0 and 2
lindex ${blist} 1

# atom with index 2 is bonded to atoms 1 and 3
lindex ${blist} 2

# radius of gyration for different frames
$sel frame first
measure rgyr ${sel}
$sel frame now
measure rgyr ${sel}
puts "======bonds===="

# to see the chain
pbc box
scale to 0.04
rotate x to -90

# print a summary of the moleculs
mol list
mol list 0

mol addrep 0
mol modstyle 1 0 Points 10.0

# Run with
# vmd -dispdev text -psf data.psf -dcd data.dcd -e selection.tcl 

set sel [atomselect top all]
# number of atoms in selection
$sel num

# list of inexes
$sel list

# shoe frame frame
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

# bonded to atom 1
lindex ${blist} 0

# bonded to atom 0 and 2
lindex ${blist} 1

# bonded to atom 1 and 3
lindex ${blist} 2

# radius of gyration
measure rgyr ${sel}

puts "======bonds===="
exit

# to see the chain
#pbc box
#scale to 0.04
#rotate x to -90

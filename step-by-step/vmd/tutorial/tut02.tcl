# assume you load file into vmd
# vmd -psf data.psf -dcd data.dcd

set sel [atomselect top all]
# number of atoms in selection
puts [$sel num]

# list of all indexes
puts [$sel list]


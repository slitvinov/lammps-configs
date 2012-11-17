package require topotools
topo readlammpsdata grid.data angle
animate write psf grid.psf

set blist {}
set natoms [molinfo top get numatoms]
for {set a 0; set b 1} {$b < $natoms} {incr a; incr b} {
    # each bond list entry is: <idx> <idx> [<type>] [<order>]
    if { [expr {$a % 5}] != 0 } {
	lappend blist [list $a $b A-A 1]
	set sel [atomselect top "index $a"]
	$sel set type 2
    } elseif { [expr {$a % 2}] != 0 } {
	set sel [atomselect top "index $a"]
	$sel set type 1
    } else {
	set sel [atomselect top "index $a"]
	$sel set type 2
    }
}
topo setbondlist both $blist
vmdcon -info "assigned [topo numbondtypes] bond types to [topo numbonds] bonds:"
vmdcon -info "bondtypes: [topo bondtypenames]"

topo guessangles
vmdcon -info "assigned [topo numangletypes] angle types to [topo numangles] angles:"
vmdcon -info "angletypes: [topo angletypenames]"

topo writelammpsdata poly.data angle
exit
set sel [atomselect top all]
namespace eval ::PBCTools:: {
    namespace export pbc*
    set blist [get_connected [$sel getbonds]]
    puts $blist
    set sel [atomselect top [join "index $blist"]]
    $sel num
    $sel get index
}

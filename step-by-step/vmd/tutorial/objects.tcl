log ~/vmd.tcl
pbc box
scale to 0.025
translate to -0.3 0 0

set glist [graphics top list]

proc addpoint { } {
    set x [expr 50*rand()]
    set y [expr 50*rand()]
    set z [expr 50*rand()]
    graphics top point  "$x $y $z"
}

user add key a addpoint


#graphics top color red
#graphics top cylinder {10 10 10} {30 30 30} radius 5

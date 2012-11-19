# http://www.ks.uiuc.edu/Research/vmd/mailing_list/vmd-l/20446.html
proc remove_long_bonds { max_length } {
     for { set i 0 } { $i < [ molinfo top get numatoms ] } { incr i } {
	 vmdcon -info "processing: $i"
         set bead [ atomselect top "index $i" ]
         set bonds [ lindex [$bead getbonds] 0 ]

         if { [ llength bonds ] > 0 } {
             set bonds_new {}
             set xyz [ lindex [$bead get {x y z}] 0 ]

             foreach j $bonds {
                 set bead_to [ atomselect top "index $j" ]
                 set xyz_to [ lindex [$bead_to get {x y z}] 0 ]
                 if { [ vecdist $xyz $xyz_to ] < $max_length } {
                     lappend bonds_new $j
                 }
             }
             $bead setbonds [ list $bonds_new ]
         }
     }
} 
function fabs(x) {
    return x ? x : -x
}

BEGIN {
    eps = 1e-12
}


NR==3 {
    print
    print 3*sw_length+1 + sw_length, "bonds"
    next
}


NR==4 {
    print
    print "3 bond types"
    next
}

/^Atoms/ {
    in_atoms = 1
    print
    getline
    print
    next
}

in_atoms&&!NF {
    in_atoms=0
}

in_atoms&&NF {
    x=$3; y=$4; z=$5
    if ( (length(np_second)==0) && (length(y_old)>0) && (fabs(y-y_old)>eps) ) {
	np_second = $1

    }
    x_old=x; y_old=y; z_old=z
}


{
    print
}

# Add bonds list
 
END {
    # line 1
    if (sw_length>0) print "\nBonds\n" #  Bonds definition : id type atom_i atom_j
    btype = 1
    for (ip=1; ip<=sw_length; ip++) {
	print ++ibond, btype, ip, ip+1
    }

    # line 2
    btype = 2
    for (ip=1; ip<=sw_length; ip++) {
	print ++ibond, btype, np_second+ip-1, np_second+ip
    }

    # vertical
    btype = 3
    for (ip=1; ip<=sw_length+1; ip++) {
	print ++ibond, btype, ip, np_second+ip-1
    }

    for (ip=1; ip<=sw_length; ip++) {
	print ++ibond, btype, ip, np_second+ip-1  + 1
    }

    print 1, sw_length > "swimmer.topology"
    print np_second, np_second+sw_length-1 >> "swimmer.topology"
    close("swimmer.topology")
}

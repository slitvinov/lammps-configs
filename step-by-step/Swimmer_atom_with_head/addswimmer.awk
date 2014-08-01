function fabs(x) {
    return x ? x : -x
}

# transform [x, y] coordiantes to id of the atom
# NOTE: uses a global variable `np_second'
function xy2id(x, y) {
    if (length(np_second)==0) {
	printf "addswimmer.awk error: np_second is not defined\n" > "/dev/stderr"
	exit
    }
    
    if (x>np_second) {
	printf "addswimmer.awk error: x>np_second\n" > "/dev/stderr"
	exit
    }
    return (np_second - 1)*(y-1) + x
}

BEGIN {
    eps = 1e-12

    # total number of bonds styles
    n_bond_types = 4

    bond_active1 = 1
    bond_active2 = 2
    
    bond_strong  = 3
    bond_passive = 4

    first_line = 3
}


NR==3 {
    print
    print 3*sw_length+1 + sw_length, "bonds"
    next
}


NR==4 {
    print
    printf "%i bond types\n", n_bond_types
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
    if (sw_length>0) print "\nBonds\n" #  Bonds definition : id type atom_i atom_j

    # line 1
    btype = bond_active1
    for (ip=1; ip<=sw_length; ip++) {
	print ++ibond, btype, xy2id(ip, first_line), xy2id(ip+1, first_line)
    }

    # line 2
    btype = bond_active2
    for (ip=1; ip<=sw_length; ip++) {
	print ++ibond, btype, xy2id(ip, first_line+1), xy2id(ip+1, first_line+1)
    }

    # vertical
    btype = bond_strong
    for (ip=1; ip<=sw_length+1; ip++) {
	print ++ibond, btype, xy2id(ip, first_line), xy2id(ip, first_line+1)
    }

    # diagonal
    for (ip=1; ip<=sw_length; ip++) {
	print ++ibond, btype, xy2id(ip, first_line), xy2id(ip+1, first_line+1)
    }

    print 1, sw_length > "swimmer.topology"
    print np_second, np_second+sw_length-1 >> "swimmer.topology"
    close("swimmer.topology")
}


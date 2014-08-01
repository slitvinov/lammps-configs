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

    first_line = 2
    sw_tail_length = int(2.0/9.0*sw_length)
}


NR==3 {
    print
    print "_PLACE_HOLDER_", "bonds"
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

function create_active_line(x_start, x_end, y_level, b_type,         btype, ip) {
    btype = b_type
    for (ip=x_start; ip<=x_end; ip++) {
	print ++ibond, btype, xy2id(ip, y_level), xy2id(ip+1, y_level)
    }
    print xy2id(x_start, y_level), xy2id(x_end, y_level) > "swimmer.topology"
}

function create_passive_line(x_start, x_end, y_level, b_type,       btype, ip) {
    btype = b_type
    for (ip=x_start; ip<=x_end; ip++) {
	print ++ibond, btype, xy2id(ip, y_level), xy2id(ip+1, y_level)
    }
}

function create_internal_line(x_start, x_end, y_level, 
			      start_closed, end_closed,
			      b_type,                               btype, ip) {
    # vertical
    btype = b_type
    for (ip=x_start + 1 - start_closed; ip<=x_end+end_closed; ip++) {
	print ++ibond, btype, xy2id(ip, y_level), xy2id(ip, y_level+1)
    }

    # diagonal
    for (ip=x_start; ip<=x_end; ip++) {
	print ++ibond, btype, xy2id(ip, y_level), xy2id(ip+1, y_level+1)
    }
}

function create_grid(x1, y1, x2, y2, b_type,                              ip, jp) {
    for (ip=x1; ip<=x2; ip++) {
	for (jp=y1; jp<=y2; jp++) {
	    if (ip<x2) print ++ibond, b_type, xy2id(ip, jp), xy2id(ip+1, jp)
	    if (jp<y2) print ++ibond, b_type, xy2id(ip, jp), xy2id(ip, jp+1)
	    if ((ip<x2) && (jp<y2)) print ++ibond, b_type, xy2id(ip, jp), xy2id(ip+1, jp+1)
	}
    }
}

END {
    # Add bonds list
    if (sw_length>0) print "\nBonds\n" #  Bonds definition : id type atom_i atom_j
    printf "" > "swimmer.topology"

    # line 1
    create_active_line(sw_tail_length+1, sw_length, first_line, bond_active1)
    create_passive_line(1, sw_tail_length, first_line, bond_passive)

    # line 2
    create_active_line(sw_tail_length+1, sw_length, first_line+1, bond_active2)
    create_passive_line(1, sw_tail_length, first_line+1, bond_passive)

    create_internal_line(1, sw_tail_length, first_line, 1, 0, bond_passive)
    create_internal_line(sw_tail_length+1, sw_length, first_line, 1, 0, bond_strong)

    create_grid(sw_length+1, first_line-1, sw_length+2, first_line+2, bond_strong)
    close("swimmer.topology")
}


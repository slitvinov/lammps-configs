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

    bond_active1 = 1 # bond style of the lower active part of the swimmer
    bond_active2 = 2 # bond style of the upper active part of the swimmer
    bond_strong  = 3 # bond style of inside bonds of the swimmer
    bond_passive = 4 # bond style of the passive (head and tail ) of the swimmer
    
    first_line = 5 # first line where the swimmer will be created
    sw_tail_length = int(2.0/9.0*sw_length) # length of the tail part
    sw_head_length = 3 # length of the head part
    sw_head_start = sw_length - sw_head_length # position where the head starts

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

# is bond on the surface on the head 
function is_same_surface(ip1, jp1, ip2, jp2) {
    # a special case for the connection between the head and the body of the swimmer
    if   (ip1==_x1 && ip2==_x1 && jp1==_y1+1 && jp2==_y1+2) return 0
    else if (ip1==ip2 && ip1==_x1) return 1
    else if (ip1==ip2 && ip1==_x2) return 1
    else if (jp1==jp2 && jp1==_y1) return 1
    else if (jp1==jp2 && jp1==_y2) return 1
    else return 0
}

function is_on_grid(ip, jp) {
    return (ip>=_x1 && ip<=_x2 && jp>=_y1 && jp<=_y2)
}

function bond_filter(ip1, jp1, ip2, jp2) {
#    if ( (ip1==_x1) && (jp1==_y1+1) && (ip2==x1+1) && (jp2==y1) ) return 1
    if ( (ip1==_x1) && (jp1==_y1+1) && (ip2==_x1+1) && (jp2==_y1) ) return 1
    if ( (ip1==_x2-1) && (jp1==_y1) && (ip2==_x2) && (jp2==_y1+1) ) return 1
    if ( (ip1==_x1) && (jp1==_y2-1) && (ip2==_x1+1) && (jp2==_y2) ) return 1
    if ( (ip1==_x2-1) && (jp1==_y2) && (ip2==_x2) &&   (jp2==_y2-1) ) return 1
    return 0
}

function make_grid_bond(ip1, jp1, ip2, jp2,                btype) {
    if (!(is_on_grid(ip1, jp1) && is_on_grid(ip2, jp2))) return 0
    if (bond_filter(ip1, jp1, ip2, jp2)) return 0
    if (is_same_surface(ip1, jp1, ip2, jp2)) {btype=bond_passive} else {btype=bond_strong}
    print ++ibond, btype, xy2id(ip1, jp1), xy2id(ip2, jp2)
}

function create_grid(x1, y1, x2, y2,                              ip, jp) {
    _x1 =x1; _y1=y1; _x2=x2; _y2=y2
    for (ip=x1; ip<=x2; ip++) {
	for (jp=y1; jp<=y2; jp++) {
	    make_grid_bond(ip, jp, ip+1, jp)
	    make_grid_bond(ip, jp, ip, jp+1)
	    make_grid_bond(ip, jp, ip+1, jp+1)
	    make_grid_bond(ip, jp, ip+1, jp-1)
	}
    }
}

END {
    # Add bonds list
    if (sw_length>0) print "\nBonds\n" #  Bonds definition : id type atom_i atom_j
    printf "" > "swimmer.topology"

    # line 1
    create_active_line(sw_tail_length+1, sw_head_start, first_line, bond_active1)
    create_passive_line(1, sw_tail_length, first_line, bond_passive)

    # line 2
    create_active_line(sw_tail_length+1, sw_head_start, first_line+1, bond_active2)
    create_passive_line(1, sw_tail_length, first_line+1, bond_passive)

    create_internal_line(1, sw_tail_length, first_line, 1, 0, bond_passive)
    create_internal_line(sw_tail_length+1, sw_head_start, first_line, 1, 0, bond_strong)

    printf "sw_length: %i\n", sw_length > "/dev/stderr"
    printf "sw_head_start: %i\n", sw_head_start > "/dev/stderr"
    printf "sw_head_length: %i\n", sw_head_length > "/dev/stderr"

    create_grid(sw_head_start+1, first_line - 1, 
		sw_head_start + 1 + sw_head_length, first_line + 2,
		bond_passive)
    close("swimmer.topology")
}


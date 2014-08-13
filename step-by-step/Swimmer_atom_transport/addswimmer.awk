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

    bond_strong  = 1 # bond style of inside bonds of the swimmer
    bond_passive = 2 # bond style of the passive (head and tail ) of the swimmer
    bond_head_flesh = 3 # bond style of the flesh in the head of the swimmer
    n_not_active_types = 3 # the number of non active type type of the bonds

    sw_start_x     = 1
    sw_start_y     = 5 # first line where the swimmer will be created
    sw_tail_length = int(2.0/9.0*sw_length) # length of the tail part
    sw_head_length = 3 # length of the head part
    sw_head_start = sw_length - sw_head_length # position where the head starts

    n_swimmer = 2 # the number of swimmers

    # total number of bonds styles
    n_bond_types = 2*n_swimmer + n_not_active_types

    bond_coef_template_top    = "bond_coeff %i harmonic/swimmer ${Umin_SW_} ${req_SW_} ${rmax_SW_} ${A_SW_} ${omega_SW_} ${phi_SW_} ${vel_sw_SW_} %i %i\n"
    bond_coef_template_bottom    = "bond_coeff %i harmonic/swimmer ${Umin_SW_} ${req_SW_} ${rmax_SW_} ${nA_SW_} ${omega_SW_} ${phi_SW_} ${vel_sw_SW_} %i %i\n"

    head_surface_type = 3
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

function create_active_line(x_start, x_end, y_level, is_top_line,        btype, ip, bond_coef_template) {
    btype = (i_swimmer - 1)*2 + n_not_active_types + is_top_line + 1
    for (ip=x_start; ip<=x_end; ip++) {
	print ++ibond, btype, xy2id(ip, y_level), xy2id(ip+1, y_level)
    }
    if (is_top_line) {bond_coef_template = bond_coef_template_top} else {bond_coef_template = bond_coef_template_bottom}
    gsub("_SW_", i_swimmer, bond_coef_template)
    
    printf bond_coef_template, btype, xy2id(x_start, y_level), xy2id(x_end, y_level) > "in.swimmer.topology"
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
    if ( (ip==_x1) && (jp==_y1) ) return 0
    if ( (ip==_x1) && (jp==_y2) ) return 0
    if ( (ip==_x2) && (jp==_y1) ) return 0
    if ( (ip==_x2) && (jp==_y2) ) return 0
    return (ip>=_x1 && ip<=_x2 && jp>=_y1 && jp<=_y2)
}

function bond_filter(ip1, jp1, ip2, jp2) {
#    if ( (ip1==_x1) && (jp1==_y1+1) && (ip2==_x1+1) && (jp2==_y1) ) return 1
#    if ( (ip1==_x2-1) && (jp1==_y1) && (ip2==_x2) && (jp2==_y1+1) ) return 1
#    if ( (ip1==_x1) && (jp1==_y2-1) && (ip2==_x1+1) && (jp2==_y2) ) return 1
#    if ( (ip1==_x2-1) && (jp1==_y2) && (ip2==_x2) &&   (jp2==_y2-1) ) return 1
#    if ( (ip1==_x1+1) && (jp1==_y2-1) && (ip2==_x2-1) &&   (jp2==_y2) ) return 1
#    if ( (ip1==_x1+1) && (jp1==_y2) &&   (ip2==_x2-1) &&   (jp2==_y2-1) ) return 1
    return 0
}

function is_head_flesh(ip, jp) {
    return (jp==_y2) || (jp==_y1)
}

function head_bond_dispatch(ip1, jp1, ip2, jp2) {
    if ((is_head_flesh(ip1, jp1)) || (is_head_flesh(ip2, jp2))) return bond_head_flesh
    if (is_same_surface(ip1, jp1, ip2, jp2)) return bond_passive
    return bond_strong
}


function make_grid_bond(ip1, jp1, ip2, jp2,                btype) {
    if (!(is_on_grid(ip1, jp1) && is_on_grid(ip2, jp2))) return 0
    if (bond_filter(ip1, jp1, ip2, jp2)) return 0
    btype = head_bond_dispatch(ip1, jp1, ip2, jp2)
    print ++ibond, btype, xy2id(ip1, jp1), xy2id(ip2, jp2)
}

function add_line_to_change_type(ip, jp,        id) {
    id = xy2id(ip, jp)
    printf "group  sw_aux id %i\nset    group sw_aux type %i\n\n", id, head_surface_type >> "in.swimmer_change_type"
}

function change_surface_type(ip) {
    for (ip=_x1; ip<=_x2; ip++) {
	if (is_on_grid(ip, _y2)) add_line_to_change_type(ip, _y2)
    }

    for (ip=_x1; ip<=_x2; ip++) {
	if (is_on_grid(ip, _y1)) add_line_to_change_type(ip, _y1)	
    }
}

function create_grid(x1, y1, x2, y2,                              ip, jp) {
    _x1 =x1; _y1=y1; _x2=x2; _y2=y2

    for (ip=_x1; ip<=_x2; ip++) {
	for (jp=_y1; jp<=_y2; jp++) {
	    make_grid_bond(ip, jp, ip+1, jp)
	    make_grid_bond(ip, jp, ip, jp+1)
	    make_grid_bond(ip, jp, ip+1, jp+1)
	    make_grid_bond(ip, jp, ip+1, jp-1)
	}
    }
    
    change_surface_type()
}

function create_swimmer() {
    i_swimmer++
    # bottom line
    create_active_line(sw_start_x + sw_tail_length+1,  sw_start_x  + sw_head_start,
		       sw_start_y, 
		       0)

    create_passive_line(sw_start_x, sw_start_x + sw_tail_length,
			sw_start_y, bond_passive)

    # top line
    create_active_line(sw_start_x + sw_tail_length+1, sw_start_x + sw_head_start, 
		       sw_start_y+1, 
		       1)

    create_passive_line(sw_start_x, sw_start_x + sw_tail_length, 
			sw_start_y+1, bond_passive)

    create_internal_line(sw_start_x, sw_start_x + sw_tail_length,
			 sw_start_y, 1, 0, bond_strong)

    create_internal_line(sw_start_x + sw_tail_length+1, sw_start_x + sw_head_start, 
			 sw_start_y, 1, 0, bond_strong)

    create_grid(sw_start_x + sw_head_start+1, sw_start_y - 1, 
		sw_start_x + sw_head_start + sw_head_length + 1, sw_start_y + 2,
		bond_passive)
}

END {
    # Add bonds list
    if (sw_length>0) print "\nBonds\n" #  Bonds definition : id type atom_i atom_j
    printf "" > "in.swimmer.topology"
    printf "" > "in.swimmer_change_type"

    sw_start_y = 2
    sw_start_x = 1
    create_swimmer()

    sw_start_y = 8
    sw_start_x = 20
    create_swimmer()

    #sw_start_y = 20
    #create_swimmer()

    close("in.swimmer.topology")
    close("in.swimmer_change_type")
}


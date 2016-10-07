#!/usr/bin/awk -f


# TEST: elliptic_cylinder.t1
# rx=6 ry=2 type=2 ./elliptic_cylinder.awk test_data/pre.data.out | awk '$2==2' > lmp.out.dat

function usage() {
    printf "%s", "elliptic_cylinder.awk: create an elliptic cylinder in lammps data file\n"              | "cat 1>&2"
    printf "%s", "usage: dim=x c1=3 c2=3 rx=1 ry=4 lo=0 hi=10 type=2 elliptic_cylinder.awk <lammps data file> > <lammps data file>\n" | "cat 1>&2"
    exit
}

function env0(n) {
    if (!(n in ENVIRON)) {
	printf "(elliptic_cylinder.awk) enviroment variable `%s' is not set\n", n | "cat 1>&2"
	usage()
    }
    return ENVIRON[n]
}

function envd(n, d) { # provide a default value
    return (n in ENVIRON ? ENVIRON[n] : d)
}

# dim c1 c2 radius lo hi type
function init() {
    pi = 3.141592653589793

    dim = envd("dim", "z") # x or y or z = axis of cylinder
    c1  = envd("c1", "C")  # coords of cylinder axis in other 2
    c2  = envd("c2", "C")  # dimensions (distance units)

    rx = env0("rx")        # semi-major axis
    ry = envd("ry", rx)    #

    lo = envd("lo", "INF") # bounds of cylinder in dim (distance
    hi = envd("hi", "INF") # units)

    new_type = env0("type") # new type of atoms in the cylinder
}

function decode_vars() {
    decode_vars_inf()
    if      (dim == "x") decode_vars_x()
    else if (dim == "y") decode_vars_y()
    else if (dim == "z") decode_vars_z()

    print "(elliptic_cylinder.awk)", "dim", "c1", "c2", "rx", "ry", "lo", "hi", "type" | "cat 1>&2"
    print "(elliptic_cylinder.awk)", dim, c1, c2, rx, ry, lo, hi, new_type | "cat 1>&2"
}

function decode_vars_inf() {
    if (lo == "INF") lo = -1e20
    if (hi == "INF") hi =  1e20
}

function decode_vars_x() { # y, z
    if (lo == "EDGE") lo = xlo; if (hi == "EDGE") hi = xhi
    if (c1 == "C") c1 = yc; if (c2 == "C") c2 = zc
}

function decode_vars_y() { # x, z
    if (lo == "EDGE") lo = ylo; if (hi == "EDGE") hi = yhi
    if (c1 == "C") c1 = xc; if (c2 == "C") c2 = zc

}

function decode_vars_z() { # x, y
    if (lo == "EDGE") lo = zlo; if (hi == "EDGE") hi = zhi
    if (c1 == "C") c1 = xc; if (c2 == "C") c2 = yc
}


BEGIN {
    init()
    if (ARGC > 2) usage()

    fn = ARGC==1 ?  "-" : ARGV[1] # input file name

    read_comment_line()
    read_count_block()   # Ex.: 100 atoms
    read_box()
    read_masses()
    read_atoms()

    decode_vars()        # decode symbolic variables (like: INF, EDGE, C (center of the domain)
    process_atoms()

    write_comment_line()
    write_count_block()
    write_box()
    write_masses()
    write_atoms()
}

function process_atoms(   ) {
    for (id in Atoms) {
	l = Atoms[id]
	parse_atom_line(l)
	update_atom()
	Atoms[id] = pack_atom_line()
    }
}

function emptyp() {return line ~ /^[ \t]*$/}

function next_line(   rc) {
    rc = getline line < fn
    nf = split(line, aline)
    return rc
}

function eat_upto_empty(   ) {
    while (next_line() > 0 && !emptyp())  ;
}

function read_comment_line() { # sets comment line
    next_line()
    comment_line = line
    eat_upto_empty()
}

function print_empty() {printf "\n"}
function typep() {return aline[3]=="types"}

function read_count_block(    type) {
    while (next_line() > 0 && !emptyp()) {
	type = aline[2]
	if (!typep())
		  count[type]=aline[1]
	else
	     type_count[type]=aline[1]
    }
}

function read_box() {
    while (next_line() > 0 && !emptyp()) {
	if (aline[3]=="xlo" && aline[4]=="xhi") {xlo=aline[1]; xhi=aline[2]}
	if (aline[3]=="ylo" && aline[4]=="yhi") {ylo=aline[1]; yhi=aline[2]}
	if (aline[3]=="zlo" && aline[4]=="zhi") {zlo=aline[1]; zhi=aline[2]}
    }
    Lx = xhi - xlo; Ly = yhi - ylo; Lz = zhi - zlo
    xc = xlo + Lx/2; yc = ylo + Ly/2; zc = zlo + Lz/2;
}

function read_masses(  type, mass) {
    eat_upto_empty()
    while (next_line() > 0 && !emptyp()) {
	type = aline[1]; mass = aline[2]; Masses[type] = mass
    }
}

function flip() { # uses x, y, z; sets x0, y0, z0
    if (dim == "x") {x0 = y; y0 = z; z0 = x}
    if (dim == "y") {x0 = z; y0 = x; z0 = y}
    if (dim == "z") {x0 = x; y0 = y; z0 = z}
}

function shift() {
    x0 -= c1; y0 -= c2
}

function update_type() {
    if (z0 <= lo) return 0
    if (z0 >= hi) return 0

    if (x0^2/rx^2 + y0^2/ry^2 >= 1) return 0
    return 1
}

function update_atom() {
    flip() # change coordinates
    shift() # move to the center of a cylinder
    if (update_type()) type = new_type
}

function parse_atom_line(l,   a, nf) { # sets id, type, x, y, z, ix, iy,
				   # iz
    nf = split(l, a)
    if (nf != 8) {printf "(elliptic_cylinder.awk) wrong number of fileds\n" | "cat 1>&2"; exit}
    id=a[1]; type=a[2]
     x=a[3];  y=a[4];  z=a[5]
    ix=a[6]; iy=a[7]; iz=a[8]
}

function pack_atom_line(   l) {
    l = id " " type " " x " " y " " z " " ix " " iy " " iz
    return l
}

function read_atoms(   ) {
    eat_upto_empty()
    while (next_line() > 0 && !emptyp()) {
	parse_atom_line(line)
	Atoms[id]=line
    }
}

function write_comment_line() {
    print comment_line
    print_empty()
}

function write_count_block(   type, numer) {
    for (type in count) {
	number = count[type]
	print number, type
    }

    for (type in type_count) {
	number = type_count[type]
	print number, type, "types"
    }
    print_empty()
}

function write_box() {
    print xlo, xhi, "xlo", "xhi"
    print ylo, yhi, "ylo", "yhi"
    print zlo, zhi, "zlo", "zhi"
    print_empty()
}

function write_masses(   type, mass, cmd) {
    print "Masses"
    print_empty()
    cmd =  "sort -g"
    for (type in Masses) {
	mass = Masses[type]
	print type, mass | cmd
    }
    close(cmd)
    print_empty()
}

function write_atoms(   id, l) {
    print "Atoms # atomic"
    print_empty()
    for (id in Atoms) {
	l = Atoms[id]
	print l
    }
    print_empty()
}

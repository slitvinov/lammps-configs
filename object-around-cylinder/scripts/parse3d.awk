#!/usr/bin/awk -f

function init() {
    pi = 3.141592653589793
}

BEGIN {
    init()
    fn = ARGC==1 ?  "-" : ARGV[1] # input file name

    read_comment_line()
    read_count_block()   # Ex.: 100 atoms
    read_box()
    read_masses()
    read_atoms()

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
}

function read_masses(  type, mass) {
    eat_upto_empty()
    while (next_line() > 0 && !emptyp()) {
	type = aline[1]; mass = aline[2]; Masses[type] = mass
    }
}

function abs(x) {return x>0 ? x : -x}
function rbc2(x, y, D0, a0, a1, a2) {
    D0 = 7.82; a0 = 0.0518; a1 = 2.0026; a2 = - 4.491
    return D0^2*(1-(4*(y^2+x^2))/D0^2)*((a2*(y^2+x^2)^2)/D0^4+(a1*(y^2+x^2))/D0^2+a0)^2
}

function shift(R, dx, dy, dz) {
    R[1] -= dx; R[2] -= dy; R[3] -= dz
}

function scale(R, sc) {
    R[1] /= sc; R[2] /= sc; R[3] /= sc
}

function rotate(R, phi,   x, y, z) {
    phi = -phi
    x = R[1]; y = R[2]; z = R[3]
    R[1] =  cos(phi)*x + sin(phi)*y
    R[2] = -sin(phi)*x + cos(phi)*y
    R[3] = z
}

function update_atom(   x0, y0, phi, R) {
    x0 = 8; y0 = 33; z0 = 16; phi = pi/2
    R[1] = x; R[2] = y; R[3] = z
    shift(R, x0, y0, z0)
    rotate(R, phi)
    scale(R, 2.0)
    
    if (rbc2(R[1], R[3])>(R[2])^2)
	type=3
}

function parse_atom_line(l,   a) {
    split(l, a)
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

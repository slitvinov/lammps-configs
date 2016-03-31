#!/usr/bin/awk -f

BEGIN {
    fn = ARGC==1 ?  "-" : ARGV[1] # input file name

    where = "read_comment_line"
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

function update_atom() {
    if (x<8 && y<8) type = 3
}

function parse_atom_line(l,   a) {
    split(l, a)
    id=a[1]; type=a[2]
     x=a[3];  y=a[4];  z=a[5]
    ix=a[3]; iy=a[4]; iz=a[5]	
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

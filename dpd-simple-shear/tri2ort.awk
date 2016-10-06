#!/usr/bin/awk -f

# Refs:
# lammps code
# [1] lammps-stokes/src/domain.cpp

function read_timestep() {
    getline < fn # ITEM: TIMESTEP
    getline timestep < fn

    print timestep
}

function read_natoms() {
    getline < fn # ITEM: NUMBER OF ATOMS
    getline natoms < fn
}

function read_box(    l) {
    getline l < fn
    if (l == "ITEM: BOX BOUNDS xy xz yz pp pp pp") {
	co_type = "tri" # triclinic coordinate system
	read_box_tri()
    }
    else if (l == "ITEM: BOX BOUNDS xx yy zz") {
	co_type = "ort" # orthogonal coordinate system
	read_box_ort()
    }

}

function read_box_ort() {
    getline < fn; xlo = $1; xhi = $2
    getline < fn; ylo = $1; yhi = $2
    getline < fn; zlo = $1; zhi = $2
}

function read_box_tri() {
    getline < fn; xlo = $1; xhi = $2; xy = $3
    getline < fn; ylo = $1; yhi = $2; xz = $3
    getline < fn; zlo = $1; zhi = $2; yz = $3

    # from [1]
    xprd = xhi - xlo
    yprd = yhi - ylo
    zprd = zhi - zlo
    h[0] = xprd; h[1] = yprd; h[2] = zprd
    h[3] = yz  ; h[4] = xz  ; h[5] = xy
    print xprd, yprd, zprd
}

function read_atoms_item(    line) { # sets `na'  : number of atom attributes
                                     #      `atts': 
    getline line < fn
    gsub("^ITEM: ATOMS ", "", line)
    na = split(line, atts)
}

function read_atoms() {
    read_atoms_item()
}

BEGIN {
    fn = ARGV[1]

    read_timestep()
    read_natoms()
    read_box()
    read_atoms()
}

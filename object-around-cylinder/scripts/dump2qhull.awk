#!/usr/bin/awk -f

BEGIN {
    eofstat = 1   # end of file status
    fn = ARGC==1 ?  "-" : ARGV[1] # input file name
    read_timestep()
    read_number_atoms()
    read_box()
    read_atoms()
}

function read_timestep() {
    getone() # ITEM: TIMESTEP
    getone()
    timestep = line
}

function read_number_atoms() {
    getone()
    getone() # ITEM: NUMBER OF ATOMS
}

function read_box() {
    getone() # ITEM: BOX BOUNDS pp pp pp
    get_and_split(); xlo = aline[1]; xhi = aline[2]
    get_and_split(); ylo = aline[1]; yhi = aline[2]
    get_and_split(); zlo = aline[1]; zhi = aline[2]
}

function parse_atom_line() {
    xs = aline[3]; ys = aline[4]; zs = aline[5]
}

function read_atoms(   cmd) {
    getone() # ITEM: ATOMS id type xs ys zs
    cmd = "qhull.m"
    cmd = cmd " | awk -v sep=',' '{print $1 sep $2 sep 0.0}'"
    print "line0"
    while (eofstat > 0) {
	get_and_split()
	parse_atom_line()
	print xs, ys | cmd
    }
    close(cmd)
}

function get_and_split() {
    eofstat = getone()
    if (eofstat > 0)
	split(line, aline)
    return eofstat
}

function getone() {
    if (eofstat <= 0) # eof or error has occurred
        return 0
    if (ungot) {      # return lookahead line if it exists
        line = ungotline
        ungot = 0
        return 1
    }
    return eofstat = (getline line < fn)
}

function unget(s)  { ungotline = s; ungot = 1 }

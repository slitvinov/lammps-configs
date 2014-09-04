# reads lammps data files and change the type of all atoms with bonds to `new_type'
# Usage:
# awk -v new_type=2 -f change_type_of_bonded.awk  data.bond data.bond > data.polymer
# Note: `data.bond' should be given two times

BEGIN {
    # if new_type is not given use new_type=2
    if (length(new_type)==0) {
	new_type = 2
    }
}

/^Bonds/ && NR==FNR {
    in_bonds = 1
    getline
    next
}

in_bonds&&!NF && NR==FNR {
    in_bonds=0
}

in_bonds&&NF && NR==FNR {
    # save bonded atom in a hash array
    b_array[$3]
    b_array[$4]
}

/^Atoms/ && NR!=FNR {
    in_atoms = 1
    print
    getline
    print
    next
}

in_atoms&&!NF && NR!=FNR {
    in_atoms=0
}

in_atoms&&NF && NR!=FNR {
    # change the type of the atoms
    if ($1 in b_array) {
	$2 = new_type
    }
}

NR!=FNR {
    print
}

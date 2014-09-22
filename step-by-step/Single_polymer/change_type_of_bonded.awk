# reads lammps data files and change the type of all atoms with bonds to `new_type'
# Usage:
# awk -v new_type=2 -f change_type_of_bonded.awk pass=1 data.bond pass=2 data.bond > data.polymer

BEGIN {
    # if new_type is not given use new_type=2
    if (length(new_type)==0) {
	new_type = 2
    }

    has_type_list = 0
    if (length(bond_type_list)!=0) {
	has_type_list = 1
	split(bond_type_list, bond_type_array)
	for (k in bond_type_array) bond_type_set[bond_type_array[k]]
    }
}

/^Bonds/ && pass==1 {
    in_bonds = 1
    getline
    next
}

in_bonds && !NF && pass==1 {
    in_bonds=0
}

in_bonds && NF && pass==1 && ( (!has_type_list) || ($2 in bond_type_set) ) {
    # save bonded atom in a hash array
    b_array[$3]
    b_array[$4]
}

/^Atoms/ && pass==2 {
    in_atoms = 1
    print
    getline
    print
    next
}

in_atoms && !NF && pass==2 {
    in_atoms=0
}

in_atoms && NF && pass==2 {
    # change the type of the atoms
    if ($1 in b_array) {
	$2 = new_type
    }
}

pass==2 {
    print
}

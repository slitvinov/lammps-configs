# reads lammps data files and adds polymer bonds
# Usage:

BEGIN {
    # number of beads
    # Nb = 3
    # number of solvents atoms between polymers
    # Ns = 0
    # number of polymer chains
    if (length(Np)==0) {
	Np = "full"
    }

    if (length(polymer_bond_type)==0) {
	polymer_bond_type = 5
    }

    if (length(polymer_candidate_type)==0) {
	polymer_candidate_type = 1
    }

    flag_polymer = 1
}

/^Bonds/ && pass==1 {
    has_bonds_block = 1
}

# output everythin
pass==1 {
    print
    next
}

pass==2 && !has_bonds_block {
    printf "\nBonds\n\n"
    has_bonds_block=1
}

/^Atoms/ && pass==2 {
    in_atoms = 1
    getline
    next
}

!NF && in_atoms && pass==2 {
    in_atoms=0
}

# 1 [2]-3-[4]
function output_polymer(last_atom_id,          i) {
    i_np++
    if (Np!="full" && i_np>Np) return
    for (i=last_atom_id - Nb + 2; i<=last_atom_id; i++) {
	print "bond_id", polymer_bond_type, i-1, i
    }
}

flag_polymer && NF && in_atoms && pass==2 {
    atom_type = $2
    i_polymer++
    if (atom_type != polymer_candidate_type) {
	i_polymer = 0
    } else if (i_polymer == Nb) {
	ID = $1
	output_polymer(ID)
	flag_polymer = 0
	i_solvent = 0
    }
}

!flag_polymer && NF && in_atoms && pass==2 {
    atom_type = $2
    if ( (i_solvent>=Ns) && (atom_type == polymer_candidate_type) ) {
	flag_polymer = 1
	i_polymer = 0
    } else {
	i_solvent++
    }
}


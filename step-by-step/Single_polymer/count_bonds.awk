# reads lammps data files, counts the number of bonds in Bonds section
# and put it into the header of lammps file
#
# awk -f count_bonds.awk pass=1 data.bond_nn pass=2 data.bond_nn > data.bond

BEGIN {
    max_bond_type=0
}

/^Bonds/ && pass==1 {
    in_bonds = 1
    getline
    next
}

in_bonds&&!NF && pass==1 {
    in_bonds=0
}

in_bonds&&NF && pass==1 {
    b_type = $2
    if (b_type>max_bond_type) max_bond_type=b_type
    b_count++
}

$2=="bonds" && NF==2 && pass==2 {
    printf "%i bonds\n", b_count
    next
}

$2=="bond" && $3=="types" && NF==3 && pass==2 {
    printf "%i bond types\n", max_bond_type
    next
}

pass==2 {
    print
}

# renumber bonds
# Usage:
# awk -f renumber_bonds.awk data.bond_nc > data.bond_nn


BEGIN {
    max_bond_type=0
}

/^Bonds/ {
    in_bonds = 1
    print
    getline
    print
    next
}

in_bonds&&!NF {
    in_bonds=0
}

in_bonds&&NF {
    n_bonds++
    $1 = n_bonds
}

{
    print
}

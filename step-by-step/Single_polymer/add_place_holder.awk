# Hold a place for the number of bonds which will be later calculated
NR==3 {
    print
    print "_n_bonds_", "bonds"
    next
}


NR==4 {
    print
    print "_n_bond_type_",  "bond types"
    next
}

{
    print
}

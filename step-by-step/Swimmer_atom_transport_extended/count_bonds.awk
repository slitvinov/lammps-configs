# reads lammps data files, counts the number of bonds in Bonds section
# and put it into the header of lammps file

# Usage: awk -v new_type=2 -f count_bonds.awk data.bond data.bond > data.polymer
# Note: `data.bond' should be given two times

BEGIN {
    
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
    b_count++
}

$2=="bonds" && NF==2 && NR!=FNR {
    printf "%i bonds\n", b_count
    next
}

NR!=FNR {
    print
}

BEGIN {
    # the number of bonds: Nb
    # Nb=10
}
#Na= Number of Angles


NR==3 {
    print
    print Nb, "bonds"
    print Na, "angles\n"
    next
}


NR==4 {
    print
    print "1 bond types"
    print "1 angle types\n"
    next
}


{
    print
}

# Add bonds list
 
END {
    if (Nb>0) print "\nBonds\n" #  Bonds definition : id type atom_i atom_j
    for (ip=1; ip<=Nb; ip++) {
	print ip, 1, ip, ip+1
    }
}

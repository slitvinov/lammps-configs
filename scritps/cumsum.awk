BEGIN {
    # index of Power
    idx = 5
}

NR>2 {
    dt = $1 - tm1
    s+= dt*$(idx)
    for (i=1; i<NF+1; i++) {
	printf $(i)" "
    }
    printf s
    printf "\n"
}

{
    xm1 = $(idx)
    tm1 = $1
}

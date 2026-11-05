BEGIN {
    system("mkdir -p pdata")
}
# reading next file
FNR==1 {
    if (length(verbose)>0) {
	printf("add new line\n") > "/dev/stderr"
    }
    # new line in all polymer files
    for (pid in allpid) {
	if (NR>1) {
	    printf "\n" >> "pdata/poly." pid
	} else {
	    printf "" > "pdata/poly." pid
	}
    }
    fl = 0
}

fl{
    pid=$8

    if (pid>0) {
	allpid[pid]=1
	print $1, $2, $3 >> "pdata/poly." pid
    }
}

/ITEM: ATOMS/ {
    fl=1
}

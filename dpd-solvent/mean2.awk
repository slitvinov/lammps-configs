#! /usr/bin/awk -f

BEGIN {
    if (length(icol)==0) {
	printf("(mean2.awk) icol should be given\n")
	exit(-1)
    }
}

NF{

    rest[FNR, icol] += $(icol)
    n[FNR]+=1

    if (FNR>maxfnr) {
	maxfnr=FNR
    }

    $(icol) = "" 
    time[FNR] = $0
}

END {
    for (q=1; q<maxfnr+1; ++q) {
	print time[q], rest[q, icol]/n[q]
    }
}
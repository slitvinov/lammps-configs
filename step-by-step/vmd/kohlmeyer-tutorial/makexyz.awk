#! /usr/bin/awk -f


BEGIN {
    if (N<=1) {
	printf("(makexyz.awk) N must be given. Run with 'awk -v N=10'\n") > "/dev/stderr"
	exit(-1)
    }
    print N
    print " linear chain of atoms"
    for (i=1; i<=N; i++) {
	printf("%i          %9.7f        %9.7f       %9.7f\n", 
	       i, 0.0, 0.0, -N/2+i+0.0)
    }
    print("\n")
}

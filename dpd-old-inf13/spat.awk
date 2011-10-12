#! /usr/bin/awk -f 
BEGIN {
  nsnap =  0
}

NF==4{
  if (n==1) {
    nspan++
  }
  n++
  if (nspan>skip) {
    x[n]=$2
    s[n]+=$4
  }
}

NF==2{
  n=0
}

END {
  for (i=1; i<n+1; i++) {
    print x[i], s[i]/(nspan-skip)
  }
  printf("nspan=%e\n", nspan) > "/dev/stderr"
}

#! /bin/bash

for file in $(ls -1 dump.dpd2.* | sort -k 3 -t . -g); do
    printf "file: %s\n" $file > "/dev/stderr"
    awk 'flag{print $3, $4, $2} /ITEM: ATOMS/{flag=1}' $file
    printf "\n"
done > punto.dat

	

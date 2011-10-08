#! /bin/bash

function post-solvent() {
    for file in $(ls -1 dump.dpd2.* | sort -k 3 -t . -g); do
	printf "file: %s\n" $file > "/dev/stderr"
	awk 'flag{print $3, $4, $2} /ITEM: ATOMS/{flag=1}' $file
	printf "\n"
    done > punto.dat
}

function post-sphere() {
    awk 'flag{print $1, $2; flag=0} /ITEM: ATOMS/{flag=1}' sphere.dpd2 > sphere.dat
    cp corr.dat corr.dat.bak
    mscilab corfun.sci file=sphere.dat output=corr.dat
    # fix strange forrmat of the output file
    awk '{for (i=1; i<NF; i++) print $i }' corr.dat | tr -d 'n\\' > /tmp/tmp-corr
    mv /tmp/tmp-corr corr.dat
}

#post-solvent
post-sphere

	

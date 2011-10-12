#! /bin/bash

USE_SCILAB_FIX=0
NDIM=3
function post-solvent() {
    for file in $(ls -1 dump.dpd${NDIM}.* | sort -k 3 -t . -g); do
	printf "file: %s\n" $file > "/dev/stderr"
	if [ ${NDIM} == 3 ]; then
	    awk 'flag{print $3, $4, $5, $2} /ITEM: ATOMS/{flag=1}' $file
	else
	    awk 'flag{print $3, $4, $2} /ITEM: ATOMS/{flag=1}' $file
	fi
	printf "\n"
    done > punto.dat
}

function post-sphere() {
    if [ ${NDIM} == 3 ]; then
	awk 'flag{print $1, $2, $3; flag=0} /ITEM: ATOMS/{flag=1}' sphere.dpd${NDIM} > sphere.dat
    else
	awk 'flag{print $1, $2; flag=0} /ITEM: ATOMS/{flag=1}' sphere.dpd${NDIM} > sphere.dat
    fi
    cp corr.dat corr.dat.bak
    mscilab corfun.sci file=sphere.dat output=corr.dat
    # fix a format of the output file
    if [ ${USE_SCILAB_FIX} == 1 ]; then
	awk '{for (i=1; i<NF; i++) print $i }' corr.dat | tr -d 'n\\' > /tmp/tmp-corr	
	mv /tmp/tmp-corr corr.dat
    fi

    msd -d 3 -f sphere.dat > sphere.msd
}

#post-solvent

if [ -r "sphere.dpd${NDIM}" ]; then
    post-sphere    
fi


	

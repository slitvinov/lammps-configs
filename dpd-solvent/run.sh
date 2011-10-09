#! /bin/bash

for aij in 5 25 75 ; do
    for K in 0.0 1e-4 1e-3 1e-2 1e-1; do
	m4 -D M4_K=${K} -D M4_aij=${aij} in.dpd.m4 > in.dpd.tmp
	../../src/lmp_linux -var ndim 2  -in in.dpd.tmp
	bash post.sh
	mkdir output-k${K}-aij${aij}
	cp *.* output-k${K}-aij${aij}/
	git clean -f
    done
done

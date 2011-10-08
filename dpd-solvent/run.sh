#! /bin/bash

for K in 0.0 1e-4 1e-3 1e-2 1e-1; do
    m4 -dM4_K=${K} in.dpd.m4 > in.dpd.tmp
    ../../src/lmp_linux -var ndim 2  -in in.dpd.tmp
    bash post.sh
    mkdir output-k${K}
    cp *.* output-k${K}/
    git clean -f
done

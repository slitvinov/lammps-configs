#! /bin/bash

for K in 20.0 30.0 50.0 80.0 ; do
    dname=k${K}a75.0mass1.0big
    mkdir ${dname}
    cp *.* ${dname}
    cd ${dname}
    m4 -DM4_K=${K} in.dpd.m4 > in.dpd
    mpirun -n 6 ../../../src/lmp_linux -var ndim 3 -var use_msd 0 -var use_sphere 1 -in in.dpd 
    bash post.sh
    cd ../
done


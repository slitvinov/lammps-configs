#! /bin/bash


for pos in $(seq 1 100); do
    m4 -DM4_FILE="<./spat.awk vy.av.${pos}" fit.m4 > fit.gp
    m=$(gnuplot fit.gp 2>&1 | awk '/grep:/{print $2}')
    echo ${pos} ${m}
done

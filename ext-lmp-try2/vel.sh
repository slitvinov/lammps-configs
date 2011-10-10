#! /bin/bash

for pos in $(seq 1 9); do
    m4 -DM4_POS=${pos} vel.m4 > vel-m.gp
    m=$(gnuplot vel-m.gp 2>&1 | awk -v FS="=" '/m=/{print $2}' )
    echo $pos $m
done



#! /bin/bash

dname="$1"
start=$(awk '$1>0.25&&$2>1{print (px+$1)/2.0;exit} {px=$1; py=$2}' ${dname}/m.dat)
awk -v s=${start} '{print $1-s, $2, $3}' ${dname}/m.dat > ${dname}/m-shifted.dat

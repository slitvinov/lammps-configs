#! /bin/bash

n=$1
file=$2
awk -v n=${n} '(i==n)&&NF==4{print} NF==2{i++} i>n{exit}' "${file}"
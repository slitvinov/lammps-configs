#! /bin/bash

msd=/media/c0c636e3-ee24-44e8-9de5-1922014ac8a1/work/googe-svn/cpp/msd/msd

rm /tmp/r-*
rm /tmp/msd-*

for ip in 865; do
    awk -v ip=${ip} '!NF{id=0} NF{id++} ip==id{print $1, $2}' punto.dat > /tmp/r-${ip}
    ${msd} -d 2 -f /tmp/r-${ip} > /tmp/msd-${ip}
done



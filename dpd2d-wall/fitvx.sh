#! /bin/bash

(gnuplot 2>&1 | awk '/grep_a/{print $2}') <<EOF
file_hi="$1"
file_low="$2"
output="$3"

set term dumb
f(x) = a*x + b
fit [20:80] f(x) file_hi u 1:4  via a, b
plot [20:80]\
     file_hi u 1:4 w lp, \
     file_low u 1:4 w lp, \
     f(x)

call "saver.gp" "$3"
print 'grep_a: ', a
EOF

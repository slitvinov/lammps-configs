#! /bin/bash

set -e
set -u

(gnuplot 2>&1 | tee log | awk '/grep_m:/{print $2}') <<EOF
v0=0.075
A = 0.1
dx=0.10
x0=0.5
p=1.0
dx(x)=abs((x-x0)/x0)
velp(x) = (1 - 2*dx(x)**(1.0+p))*v0*(x0**2) + A
fit [dx:1.0-dx] velp(x) "$1" via p, v0, A
set term dumb
plot velp(x), "$1"
call "saver.gp" velp
print 'grep_m: ', p
EOF

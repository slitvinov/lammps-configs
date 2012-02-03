unset log
reset

set macro
st='l'
fun='(abs($1))'

set log xy

set term x11 1
plot [:400][1e-3:1.0] \
     "k0.01a75.0/corr.dat" u @fun w @st, \
     "k0.03a75.0/corr.dat" u @fun w @st, \
     "k0.10a25.0/corr.dat" u @fun w @st, \
     "k0.10a75.0/corr.dat" u @fun w @st, \
     "k0.10a75.0T0.25/corr.dat" u @fun  w @st, \
     "k0.31a75.0/corr.dat" u @fun  w @st, \
     x**(-3/2)

set term x11 2
plot \
     "k0.01a75.0/sphere.msd" w @st, \
     "k0.03a75.0/sphere.msd" w @st, \
     "k0.10a25.0/sphere.msd" w @st, \
     "k0.10a75.0/sphere.msd" w @st, \
     "k0.10a75.0T0.25/sphere.msd" w @st, \
     "k0.31a75.0/sphere.msd" w @st



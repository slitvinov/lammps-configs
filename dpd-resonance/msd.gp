# plot msd

set log x
set xlabel "1/t"
set ylabel "1/6*msd/t"
set macro
st='(1.0/$1):($2/$1/6.0)'
plot [:0.1][] \
     "msd.dat"  u @st w lp t "solvent", \
     "msd-col.dat" u @st  w lp t "particle"

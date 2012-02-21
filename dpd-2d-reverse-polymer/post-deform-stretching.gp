set log
rho=3.0
eta_solvent=9.0*rho

# in data file
# R stforce sxy gamma(output)

plot [][18:50]\
     "solvent.dat" u 1:($3/$1) w lp lw 3, \
     "<awk '$2==0' gamma-deform-stretching.dat" u 1:($3/$1) w lp, \
     "<awk '$2==10' gamma-deform-stretching.dat" u 1:($3/$1) w lp, \
     "<awk '$2==50' gamma-deform-stretching.dat" u 1:($3/$1) w lp, \
     "<awk '$2==100' gamma-deform-stretching.dat" u 1:($3/$1) w lp, \
     "<awk '$2==150' gamma-deform-stretching.dat" u 1:($3/$1) w lp, \
     "<awk '$2==200' gamma-deform-stretching.dat" u 1:($3/$1) w lp, \
     eta_solvent



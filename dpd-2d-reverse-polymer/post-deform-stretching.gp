set size 0.60
set log
rho=3.0
eta_solvent=9.0*3.0

# in data file
# R stforce sxy gamma(output)

plot [][18:50]\
     "<awk '$2==0' solvent.dat" u 1:($3/$1) w lp t "solvent", \
     "<awk '$2==0' gamma-deform-stretching.dat" u 1:($3/$1) w lp lw 3 t "f=0", \
     "<awk '$2==10' gamma-deform-stretching.dat" u 1:($3/$1) w lp lw 3 t "f=10", \
     "<awk '$2==20' gamma-deform-stretching.dat" u 1:($3/$1) w lp lw 3 t "f=20", \
     "<awk '$2==50' gamma-deform-stretching.dat" u 1:($3/$1) w lp lw 3 t "f=50", \
     "<awk '$2==100' gamma-deform-stretching.dat" u 1:($3/$1) w lp lw 3 t "f=100", \
     "<awk '$2==200' gamma-deform-stretching.dat" u 1:($3/$1) w lp lw 3 t "f=200", \
	eta_solvent


call "saver.gp" "deform-st"
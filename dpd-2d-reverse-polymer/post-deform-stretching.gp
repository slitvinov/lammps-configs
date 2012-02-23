set log
rho=3.0
eta_solvent=42.0

# in data file
# R stforce sxy gamma(output)

plot [][40:70]\
     "<awk '$2==0' gamma-deform-stretching3d.dat" u 1:($3/$1) w lp, \
     "<awk '$2==20' gamma-deform-stretching3d.dat" u 1:($3/$1) w lp, \
     "<awk '$2==50' gamma-deform-stretching3d.dat" u 1:($3/$1) w lp, \
     "<awk '$2==100' gamma-deform-stretching3d.dat" u 1:($3/$1) w lp, \
	eta_solvent



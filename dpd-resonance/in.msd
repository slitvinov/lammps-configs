group solvent  type 1
compute cmsd_all solvent msd
variable vmsd equal c_cmsd_all[4]
fix amsd_fix all print 100 "${time} ${vmsd}" file "msd.dat"



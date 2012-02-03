set log
set key bottom left
plot [:1000][1.1e-3:1.0] "k0.01a75.0/corr.dat" w l lw 3, \
     "k0.01a25.0/corr.dat" w l lw 3, \
     "k0.01a5.0/corr.dat" w l lw 3, \
     110*x**(-3.0/2.0) w l lw 2, \
     1200*x**(-4.0/2.0), \
     7*x**(-2.0/2.0)

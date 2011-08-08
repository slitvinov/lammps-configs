set xlabel "x"
set ylabel "v_{y}, velosity" offset character 2.5, 0
set y2label "tau_{xy}, shear stress"

set key left

L = 6.0
rho = 6.0
gz = 0.0557
eta = 2.02
par(x) = rho*gz/(2*eta)*(x*L - x**2)
f(x) = -par(x)*(x<L)*(x>0) +par(x-L)*(x>L)*(x<2*L)

plot "vy.av" u 2:4 w lp t "v_{y}", \
     "sxy.av" u 2:4 w lp t "tau_{xy}", \
     f(x) t "theoretical"

call "/scratch/work/google-svn/gnuplot/saver.gp" "av"
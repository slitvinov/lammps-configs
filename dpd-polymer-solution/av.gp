set xlabel "x"
set ylabel "v_{y}, velosity" offset character 2.5, 0
set y2label "tau_{xy}, shear stress"

file="data2d/vy.av.25"

set key left
vmax = 0.01
L = 25.0
A = 4.0*vmax/(L**2)
par(x) = -A*(x*L - x**2) 
f(x) = par(x)*(x<L)*(x>0) - par(x-L)*(x>L)*(x<2*L)

C = -0.01
A = 1e-4
fit [0:L] -A*(x*L - x**2)+C  file via A, C

plot [0:L] file u 2:4 w lp t "v_{y}", -A*(x*L - x**2)+C

file="<awk '$2==0' gamma-deform-stretching.dat"

m=-0.40745297553551
n=10.4797428047832
alpha=86.0910874643814
eta0= 44.0
etainf=25.3037918349903
f(x) = (eta0 - etainf) * (1 + (alpha*x)**n )**(m/n) + etainf

fit f(x) file u 1:($3/$1) via alpha, etainf, n, m

set log
plot [6e-3:3.0][26.0:45.0] file u 1:($3/$1) w lp lw 3, f(x)
set macros

limts='[0.3:1.3*tau][8.5:40]'
etainf = 8.8
eta0= 35.0
lambda = 14.0
a=1.0
n=0.1

tau=53.0
cy(g) = etainf + (eta0-etainf) * (1 + (lambda*g)**a)**( (n-1)/a )

#fit cy(x) "gamma.long" @st via eta0

st="u ($1*tau):($2/$1) w lp lw 3"
set log
plot @limts \
     "gamma.polymer" @st t "LE1", \
     "gamma.long" @st t "LE2", \
     "gamma.wall" u ($1*tau):($2/$1*1.1) w lp lw 3 t "Couette with force on wall", \
     "gamma.solvent" @st t "solvent", \
     cy(x/tau) w l lw 3 t "CY model"
     

call "saver.gp" "gamma2D"
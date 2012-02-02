
set xlabel "time"
set ylabel "position autocorrelation"
plot [0:100] \
     "corr.dat" w l lw 3 t "last", \
     "corr.dat.bak" w l lw 1 t "prev", 0 t ""
call "saver.gp" "corr"

set xlabel "time"
set ylabel "msd"
plot [0:100] \
     "sphere.msd" w l lw 3 t "last"
call "saver.gp" "msd"

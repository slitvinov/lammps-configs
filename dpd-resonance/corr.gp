
set xlabel "time"
set xlabel "position autocorrelation"
plot [0:1000] \
     "corr.dat" w l lw 3 t "last", \
     "corr.dat.bak" w l lw 1 t "prev"
call "saver.gp" "corr"
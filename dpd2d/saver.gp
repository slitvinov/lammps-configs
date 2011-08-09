set term push
set term postscript enhanced color
set output sprintf("%s.eps", "$0")
replot

set terminal png enhanced
set output sprintf("%s.png", "$0")
replot

set term pop
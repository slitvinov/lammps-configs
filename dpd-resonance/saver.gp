set term push
set term postscript enhanced color
set output sprintf("%s.eps", "$0")
replot

system( sprintf("epstopdf %s.eps --outfile=%.pdf", "$0") )

set terminal png
set output sprintf("%s.png", "$0")
replot
set output

set term pop
replot
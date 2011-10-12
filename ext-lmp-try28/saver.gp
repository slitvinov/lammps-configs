set term push
set terminal png
set output sprintf("%s.png", "$0")
replot
set output

set term pop
replot
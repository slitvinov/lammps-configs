set term png
set output "rg.png"

plot "print/rg.dat" u 1:(-$2), 0.2, 0.2/2

set output
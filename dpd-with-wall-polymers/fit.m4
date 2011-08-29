file="M4_FILE"

L=25.0
m = 2.0
vmax=3.5
b=L/2.0
a=0.0256
g(x) = -a*(abs(b-x))**(m+1) + vmax
lim=5

set term png
set output "hm.png"
fit [lim:L-lim] g(x) file via a, vmax, m
plot file, g(x)


print "grep: ", m

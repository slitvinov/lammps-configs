set term dumb

L=64.0
m = 1.0
vmax=3.09236030555307
b=0.5*L
g(x) = -(a * abs(b-x))**(m+1) + vmax
fq=0.10
limit="[fq*L:(1.0-fq)*L]"
file="<./spat.awk  -v skip=12 vy.av"
file13="<./spat.awk  -v skip=12 ../dpd-old-inf13/vy.av"
fit @limit g(x)  file  via m, vmax, a, b

plot \
     file w lp lw 3 t "inf14", \
     file13 w lp lw 3 t "inf13", \
     g(x) t sprintf("m=%f", m)
call "saver.gp" vel

plot [][-2:2]\
     "<./spat.awk sxy.av" w lp lw 3 t "tot stress", \
     "<./spat.awk sxy_poly.av" w lp lw 3 t "polymer stress"

call "saver.gp" stress

print "m=", m
print "vmax=", vmax
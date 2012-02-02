set term dumb

L=64.0
m = 1.0
vmax=12.0
b=0.5*L
g(x) = -(a * abs(b-x))**(m+1) + vmax
fq=0.20
limit="[fq*L:(1.0-fq)*L]"
file="<./spat.awk  -v skip=0 vy.av"
fit @limit g(x)  file  via m, vmax, a, b

plot file w lp lw 3, g(x) t sprintf("m=%f", m)
call "saver.gp" vel

plot "<./spat.awk sxy.av" w lp lw 3 t "tot stress", \
     "<./spat.awk sxy_poly.av" w lp lw 3 t "polymer stress" 
call "saver.gp" stress

print "m=", m
print "vmax=", vmax
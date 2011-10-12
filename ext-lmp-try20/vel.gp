set term dumb

L=64.0
m = 1.0
vmax=14
b=0.5*L
a=-0.136430736392363
g(x) = -(a * abs(b-x))**(m+1) + vmax
fq=0.20
limit="[fq*L:(1.0-fq)*L]"
file_st="<./spat.awk -v skip=30 vy.av.10"
file_rel="<./spat.awk -v skip=30 vy.av.90"
fit @limit g(x)  file_rel  via vmax, m, a, b

plot [0:L] \
     g(x) t sprintf("m=%f", m) w l lw 3, \
     file_st w lp lw 3, \
     file_rel w lp lw 3

     
call "saver.gp" vel

plot "<./spat.awk sxy.av" w lp lw 3 t "tot stress", \
     "<./spat.awk sxy_poly.av" w lp lw 3 t "polymer stress" 
call "saver.gp" stress

print "m=", m
print "vmax=", vmax
print "a=", a

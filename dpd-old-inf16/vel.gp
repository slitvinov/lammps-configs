set term dumb

L=64.0
m_st = m = 1.0
vmax_st = vmax=3.09236030555307
b_st = b=0.5*L
g(x) = -(a * abs(b-x))**(m+1) + vmax
f(x) = -(a_st * abs(b_st-x))**(m_st+1) + vmax_st
fq=0.2
limit="[fq*L:(1.0-fq)*L]"
file_st="<./spat.awk vy.av.[3][0-9]"
file_rel="<./spat.awk vy.av.[8][0-9]"

fit @limit g(x)  file_rel  via m, vmax, a, b
fit @limit f(x)  file_st  via m_st, vmax_st, a_st, b_st

plot \
     file_st w lp lw 3 t "file_st", \
     file_rel w lp lw 3 t "file_rel", \
     g(x) t sprintf("m=%f", m), \
     f(x) t sprintf("m_st=%f", m_st)

call "saver.gp" vel

plot [][-2:2] \
     "<./spat.awk sxy.av" w lp lw 3 t "tot stress", \
     "<./spat.awk sxy_poly.av" w lp lw 3 t "polymer stress" 
call "saver.gp" stress

print "m=", m
print "m_st=", m_st

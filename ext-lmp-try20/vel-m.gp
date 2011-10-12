set term dumb

L=64.0
m = 1.0
vmax =3.09236030555307
b=0.5*L
g(x) = -(a * abs(b-x))**(m+1) + vmax
fq=0.2
limit="[fq*L:(1.0-fq)*L]"
file_rel="<./spat.awk -v skip=14 vy.av.[81]"

fit @limit g(x)  file_rel  via m, vmax, a, b

print "m=", m

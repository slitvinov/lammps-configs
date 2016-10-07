set macro
set term x11

sec(x)=1/cos(x)
pow(a, b)=a**b
f0(t)=pow(a,2.0)*pow(pow(b,2.0)+pow(a,2.0),-1.0)*k \
          *pow(sec(a*b*pow(pow(b,2.0)+pow(a,2.0),-1.0)*k*t),2.0) \
          *pow(pow(a,2.0)*pow(b,-2.0) \
                         *pow(tan(a*b*pow(pow(b,2.0)+pow(a,2.0),-1.0)*k*t), \
                              2.0) \
                +1.0,-1.0)

f(t) = f0(t - s)               

a=1.0

b=2.0
k=0.1
s=-13

fn='"print/rg.dat" u 1:(-$2)'
gn='"~/rg.dat" u 1:(-$2)'
fit [100:] f(x) @fn via s, k, b

plot @fn w l, @gn w l, f(x)

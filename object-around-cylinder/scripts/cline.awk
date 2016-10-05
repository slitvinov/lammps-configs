#!/usr/bin/awk -f

BEGIN {
    r  = 16; xc = 32; yc = 32; zc = 1
    
    pi = 3.141592653589793
    pl = 0
    ph = 2*pi
    n = 100
    h = (ph - pl)/(n-1)
    
    for (i=p=0; i<n; i++) {
	x = xc + r*cos(p); y = yc + r*sin(p); z = 0
	print x "," y "," z
	p+=h
    }
    
}

#!/usr/bin/awk -f

function envd(n, d) { # provide a default value
    return (n in ENVIRON ? ENVIRON[n] : d)
}

BEGIN {
    pi = 3.1415926
    n = 100 # number of points
    
    rx = envd("rx", 1) # semi-major axis
    ry = envd("ry", rx)

    xc = envd("xc", 0) # center of an ellipse
    yc = envd("yc", 0) #

    sc = envd("sc", 1) # scale the ellipse
    rx *= sc; ry *= sc 

    printf "ellipse (rx=%s, ry=%s, xc=%s, yc=%s)\n", rx, ry, xc, yc
    for (i=0; i<=n; i++) {
	phi = i/n * 2*pi
	x = xc + rx*cos(phi); y = yc + ry*sin(phi); z = 0
	print x "," y "," z
    }
}

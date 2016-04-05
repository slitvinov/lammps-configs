#!/usr/bin/octave -qf

#### Make a convex hull for 2D point data
#### Usage:
#### ./qhull.m < xy.rnd.dat

data = dlmread(stdin());

x = data(:, 1);
y = data(:, 2);

idx = convhull(x, y);
xh = x(idx);
yh = y(idx);

dlmwrite(stdout(), [xh, yh], ' '); 

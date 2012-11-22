# generate data with
# ../../src/lmp_linux -in in.polydump
# run with
# PYTHONPATH=/home/vital303/work/Pizza.py/src python2.7 sphdump.py
# For emacs set
# (setenv "PYTHONPATH" "/home/vital303/work/Pizza.py/src")

import dump
import bdump
d = dump.dump("pdump*.dat")

# atom attributes
x = d.atom(1, "x")
m1, m2 = d.minmax("x")

b = bdump.bdump("bdump.dat")
b.map(1,"id",2,"type",3,"atom1",4,"atom2")

d.extra(b)
time,box,atoms,bonds,tris,lines = d.viz(1)

d.viz(1)

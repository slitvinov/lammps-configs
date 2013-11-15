# work with data file
# data.py from Pizza should be on PYTHONPATH
# PYTHONPATH=/scratch/work/Pizza.py/src/ python polyread.py
import data

# export a data file
print "reading polyr.data"
d = data.data("polymer.data")

# add a new bond
d.sections["Bonds"] = ['1 1 1 3\n', '1 1 1 4\n']
d.headers["bonds"] = 2

# write a data file
print "writing out.dat"
d.write("out.dat")


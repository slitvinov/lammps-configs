# work with data file
import data

# export a data file
d = data.data("polymer.data")

# add a new bond
d.sections["Bonds"] = ['1 1 1 3\n', '1 1 1 4\n']
d.headers["bonds"] = 2

# write a data file
d.write("out.dat")


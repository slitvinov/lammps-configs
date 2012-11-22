# work with data file
import numpy
import argparse
import data

parser = argparse.ArgumentParser(description='Add polymers to the periodic box')
parser.add_argument('--input', type=str, action="store", dest="inputfile",
                   help='output file name')
parser.add_argument('--output', type=str, action="store", dest="outputfile",
                   help='input file name')
parser.add_argument('--Nb', type=int, action="store", dest="Nb",
                   help='number of beads in one chain')
parser.add_argument('--Ns', type=int, action="store", dest="Ns",
                   help='number of solvent atoms for one chain')
parser.add_argument('--Np', type=str, action="store", dest="Np",
                   help='number of polymer chain (--Np full means fill entire domain)')

args = parser.parse_args()
Nb = args.Nb
Ns = args.Ns

# export a data file
d = data.data(args.inputfile)
Natoms = d.headers["atoms"]
# an array for atom types
atomtype = numpy.ones(Natoms+1, dtype=int)

# an array for molecular id
# 0: for all solvent
# 1..Np: for polymer chains
molid = numpy.zeros(Natoms+1, dtype=int)

if args.Np == "full":
    Np = Natoms
else:
    Np = int(float(args.Np))

def isbond(iatom):
    period = Ns + Np
    rem = (iatom-1)%(period) # from 0 to period-1
    current_npoly = int(iatom/period) + 1
    return (rem<Nb-1) and (iatom<Natoms) and (current_npoly<=Np)

# create bond section
bnd = []
ibond = 0
bondtype = 1
ichain = 1
R = numpy.zeros([Natoms, 3])
rlo = numpy.array(d.maxbox()[:3])
rhi = numpy.array(d.maxbox()[3:])
box = rhi - rlo

R[:, 0] = d.get("Atoms", 4)
R[:, 1] = d.get("Atoms", 5)
R[:, 2] = d.get("Atoms", 6)

image = numpy.zeros([Natoms, 3], dtype=int)
cimage = numpy.zeros(3)

for iatom in range(1, Natoms+1):
    if isbond(iatom):
        atomtype[iatom-1] = 2
        atomtype[iatom] = 2
        molid[iatom-1] = ichain
        molid[iatom] = ichain
        ibond = ibond + 1
        bnd.append( "%i %i %i %i\n" % (ibond, bondtype, iatom, iatom+1) )
        in_polymer_flag = True
        for dim in [0, 1, 2]:
            if abs(R[iatom, dim] - R[iatom-1, dim]) > 0.5*box[dim]:
                cimage[dim] = cimage[dim] + 1
        image[iatom, :] = cimage
    elif in_polymer_flag:
        ichain = ichain + 1
        in_polymer_flag = False
        cimage = numpy.zeros(3)
print ( "created: %i chains\n"  % ichain)

d.sections["Bonds"] = []
# add a new bond
d.sections["Bonds"] = bnd

d.headers["bonds"] = len(bnd)
d.headers["bond types"] = 1
d.headers["atom types"] = 2
molididx=2
d.replace("Atoms", molididx, molid)
typeid=3
d.replace("Atoms", 7, image[:, 0])
d.replace("Atoms", 8, image[:, 1])
d.replace("Atoms", 9, image[:, 2])

d.replace("Atoms", typeid, atomtype)
d.delete("Masses")

# write a data file
d.write(args.outputfile)


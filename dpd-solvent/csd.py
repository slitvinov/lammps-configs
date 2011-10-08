from matplotlib.mlab import csd, psd
from pylab import vstack, hstack
from math import pow

from matplotlib.mlab import detrend_mean
from numpy import loadtxt, savetxt

from optparse import OptionParser
parser = OptionParser()
parser.add_option("-f", "--file", dest="filename")
parser.add_option("-p", "--power", type="int", dest="power", default=int(14))
parser.add_option("-e", "--overlap", type="int", dest="overlap", default=int(10))
parser.add_option("-o", "--output", type="string", dest="output", default="output.dat")
(options, args) = parser.parse_args()

print "options.power = ", options.power
print "options.overlap = ", options.overlap

x = loadtxt(options.filename)
print "x.shape = ", x.shape
print "x.ndim = ", x.ndim

if x.ndim==1: 
    psx, fr = psd(x, NFFT=2**options.power, detrend=detrend_mean, noverlap=options.overlap)
elif x.ndim==2: 
    psx, fr = csd(x[:, 0], x[:, 1], NFFT=2**options.power, detrend=detrend_mean, noverlap=options.overlap)
else:
    raise(DimensionError)

fr = fr.reshape(-1, 1)
psx = psx.reshape(-1, 1)
print "psx.shape = ", psx.shape
print "fr.shape = ", fr.shape

savetxt(options.output, hstack((fr, abs(psx))))

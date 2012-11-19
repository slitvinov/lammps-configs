# assume you load file into vmd
# vmd -psf data.psf -dcd data.dcd

# to get better veiw
pbc box
scale to 0.04
rotate x to -90

animate forward
animate pause

animate goto 1
animate goto 10

animate delete all
animate read psf data.psf

# cannot read only part of the frames
animate read dcd data.dcd
#topo readlammpsdata grid.data angle
animate read psf poly.psf
topo readlammpsdata poly.data angle
pbc join connected -all -verbose
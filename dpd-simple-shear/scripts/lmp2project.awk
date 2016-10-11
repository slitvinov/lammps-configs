#!/usr/bin/awk -f

# TEST: lmp2project_t1
# export xlo=0 xhi=64 ylo=0 yhi=64 zlo=-0.01 zhi=0.01
# export nx=64 ny=64 nz=1
# ./lmp2project.awk test_data/d.0.dump  > n.out.vtk

function init() {
    xlo = eread("xlo"); xhi = eread("xhi")
    ylo = eread("ylo"); yhi = eread("yhi")
    zlo = eread("zlo"); zhi = eread("zhi")

    nx = eread("nx"); ny = eread("ny"); nz = eread("nz")
    Lx = xhi - xlo; Ly = yhi - ylo; Lz = zhi - zlo
    dx = sp(Lx, nx); dy = sp(Ly, ny); dz = sp(Lz, nz)
}

function eread(n) {
    if (!(n in ENVIRON)) {
	printf "(lmp2project.awk) `%s' environment variable should be set\n", n | "cat 1>&2"
	return_code = -1
	exit
    }
    return ENVIRON[n]
}

function sp(L, n) { # spacing
    return L/n
}

function r2i(r, rlo, dr) {
    r -= rlo
    r /= dr
    return int(r)
}

function i2r(i, rlo, dr,    r) {
    r  = i*dr
    r += dr/2
    return r
}

function x2i(x) {return r2i(x, xlo, dx)}
function y2i(y) {return r2i(y, ylo, dy)}
function z2i(y) {return r2i(z, zlo, dz)}

function i2x(i) {return r2i(i, xlo, dx)}
function i2y(i) {return r2i(i, ylo, dy)}
function i2z(i) {return r2i(i, zlo, dz)}

function open_file() { # set input file `f' and the number of `nfile'
    nfile = ARGC - 1 # number of files to read
    if (ifile>=nfile) return 0
    else              f = ARGV[ifile+1]

    printf "(lmp2project.awk) processing: %s\n", f | "cat 1>&2"
    return 1
}

function close_file() { # updates `ifile'
    ifile++
    if (f!="-") close(f)
}

function next_line(    rc) {
    rc = getline l < f
    return rc
}

function read_header() {
    while (next_line() && l !~ /ITEM: ATOMS/ )
	;
}

function parse_item_line(   n, i, a, e) {
    sub(/^[ \t]*ITEM: ATOMS[ \t]*/, "", l)
    n = split(l, a)
    for (i=1; i<=n; i++)  {
	e = a[i]
	if      (e=="xs") xsidx = i
	else if (e=="ys") ysidx = i
	else if (e=="zs") zsidx = i
	else if (e=="vx") vxidx = i
	else if (e=="vy") vyidx = i
	else if (e=="vz") vzidx = i	
    }
}

function unpack_atom_line(   n, a) {
    n = split(l, a)
    xs = a[xsidx]; ys = a[ysidx]; zs = a[zsidx]
    x = xlo + xs*Lx
    y = ylo + ys*Ly
    z = zlo + zs*Lz

    vx = a[vxidx]; vy = a[vyidx]; vz = a[vzidx]
}

function read_atoms(   iatoms) { # sets `xx', `yy', `zz', and `natoms'
    natoms = 0
    while (next_line()) {
	unpack_atom_line()
	xx[iatoms] = x; yy[iatoms] = y; zz[iatoms] = z
	vvx[iatoms] = vx; vvy[iatoms] = vy; vvz[iatoms] = vz
	iatoms++
    }
    natoms = iatoms
}

function unpack_atom_arrays(i) {
    x = xx[i];    y = yy[i];   z = zz[i]
    vx = vvx[i]; vy = vvy[i]; vz = vvz[i]
}

function set_atom_cell() {
    ix = x2i(x); iy = y2i(y); iz = z2i(z)
}

function project_atom() {
    gvx[ix, iy, iz] += vx
    gvy[ix, iy, iz] += vy
    gvz[ix, iy, iz] += vz
    gn [ix, iy, iz] += 1
}

function process_atoms(   iatoms) {
    for (iatoms=0; iatoms<natoms; iatoms++) {
	unpack_atom_arrays(iatoms) # sets `x', `y', `z', `vx', `vy',
				   # `vz'
	set_atom_cell()
	project_atom()
    }
}

function file_version() {
    printf "# vtk DataFile Version 2.0\n"
}

function header() {
    printf "Created with lmp2project.awk\n"
}

function format() {
    printf "ASCII\n" # ASCII, BINARY
}

function topology() {
    structured_points()
    printf "\n"
}

function structured_points() {
    printf "DATASET STRUCTURED_POINTS\n"
    printf "DIMENSIONS %d %d %d\n", nx, ny, nz
    printf "ORIGIN %g %g %g\n"    , xlo, ylo, zlo
    printf "SPACING %g %g %g\n"   , dx, dy, dz
}

function dataset(var, grid,    dataType, v, n, ix, iy, iz) {
    dataName = var
    dataType = "float"
    printf "SCALARS %s %s\n", dataName, dataType
    printf "LOOKUP_TABLE default\n"

    for (iz=0; iz<nz; iz++)
	for (iy=0; iy<ny; iy++)
	    for (ix=0; ix<nx; ix++) {
		v = grid[ix, iy, iz]
		printf "%.12g\n", v
	    }
    printf "\n"
}

function cell_volume(  edx, edy, edz) {
    edx = nx > 1 ? dx : 1
    edy = ny > 1 ? dy : 1
    edz = nz > 1 ? dz : 1
    return edx*edy*edz
}

function process_grid(   ix, iy, iz, n, V) {
    V = cell_volume()
    
    for (iz=0; iz<nz; iz++)
	for (iy=0; iy<ny; iy++)
	    for (ix=0; ix<nx; ix++) {
		n = gn[ix, iy, iz]
		if (!n) continue
		gvx[ix, iy, iz] /= n
		gvy[ix, iy, iz] /= n
		gvz[ix, iy, iz] /= n
		gnd[ix, iy, iz] = n/nfile/V
	    }
}

function point_data() {
    printf "POINT_DATA %d\n", nx*ny*nz
    dataset("vx", gvx)
    dataset("vy", gvy)
    dataset("vz", gvy)
    dataset("nd", gnd)
    dataset("n" , gn)
}

BEGIN {
    init()

    while (open_file()) {
	read_header()
	parse_item_line()
	read_atoms()
	close_file()
	process_atoms()
    }
    
    process_grid()

    file_version()
    header()
    format()
    topology()
    point_data()
}

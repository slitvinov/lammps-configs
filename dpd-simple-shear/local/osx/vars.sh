rx=4 # semi-major axis of a solid cylinder
ry=2

solid_type=2

vars=""

# shell scripts parameters for run on osx
np=4 # number of processor

use_vtk=0 # compile lammps with USER-VTK package

# lammps source code directory (in $HOME/src)
lmp_dir=lammps-stokes
lmp_repo=https://github.com/slitvinov/lammps-stokes.git
lmp_pkg="yes-RIGID "

# gdb related
gdb_cmd=gdb
gdb_script=/tmp/gdb.$$.cmd
lmp_dbg=lmp_dbg

make_trg=mpi # lammps compilation target
make_np=4 # number of process to make


set_vtk() {
    lmp_pkg+=" yes-USER-VTK"
    vtk_ver=6.3 # version of VTK library
    vlibs="-lvtkIOParallelXML-${vtk_ver} -lvtkCommonCore-${vtk_ver} \
           -lvtkIOCore-${vtk_ver} -lvtkIOXML-${vtk_ver} -lvtkIOLegacy-${vtk_ver} -lvtkCommonDataModel-${vtk_ver}"
    make_env+=" vtk_SYSINC=-I/usr/local/include/vtk-${vtk_ver}"
    make_env+=" vtk_SYSPATH=-L/usr/local/lib"
    make_env+=" vtk_SYSLIB=\"${vlibs}\""
}

if test ${use_vtk} -eq 1
then
    set_vtk
else
    make_env=""
fi



# lammps-configs

- `dpd-2d-solvent`: 2D solvent in equilibrium, LE, and reverse flow
- `dpd-2d-polymer-le`: 2D polymer in LE
- `dpd-3d-polymer-le`: 3D polymer in LE
- `dpd-2d-polymer-wall`: 2D polymer with moving walls

## LAMMPS 2026

Branch `lammps2026` runs with current LAMMPS (30 Sep 2026).

```
cp src/* lammps/src/
cd lammps/src
make yes-MOLECULE yes-DPD-BASIC yes-DPD-SMOOTH yes-SPH yes-GRAPHICS yes-EXTRA-DUMP
make -j mpi LMP_INC="-DLAMMPS_GZIP -DLAMMPS_JPEG" JPG_LIB=-ljpeg
```

The mfsph inputs also need the multiphase styles from
https://github.com/slitvinov/lammps-sph-multiphase (`MULTIPHASE/*`).

Run scripts use `LMP` and `MPIRUN`, e.g. `LMP=lmp_mpi bash run.sh`.

Reconstructed (the 2012 sources are lost):
- pair dpd with weight exponent and two cutoffs: `dpd/ext` + `dpd`
- `bond_style stretching`: `src/bond_stretching.cpp`
- chain2: `scripts/mkchain.sh` and `create_atoms mol` in `in.generator`
- pair sdpd: `sdpd/taitwater/isothermal`
- mfsph: `sph/rhosum/multiphase` + `sph/taitwater/multiphase`
- `wall/reflect` reftype back: plain `wall/reflect`

## Examples

Reverse Poiseuille flow, `dpd-2d-solvent/in.reverse`

![reverse Poiseuille](img/reverse-poiseuille.svg)

SPH flow around a periodic array of cylinders,
`lammps-sph-flow-around-cylinder/in.cylinder`, compared with Morris et
al. (1997)

![SPH cylinder](img/sph-cylinder.svg)

2D polymer solution under Lees-Edwards shear, `dpd-2d-polymer-le`

![polymers in shear](img/polymers-shear.gif)

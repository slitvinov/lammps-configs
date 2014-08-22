## SPH-Simulation with a Swimmer ##

This package includes swimmers into a SPH-simulation.

To set the simulation, the follow files must be edited to define the simulation
configuration:

- in.vars ( define simulation variables)
- in.geinit ( define initial setting to generate simulation box)
- adddsiwmmer.awk ( set parameters to generate the swimmer profile)
- in.swimmer ( define bond coefficients of the swimmers)
- in.run ( define simulation running settings)
- run.sh ( executable file to run the simulation)

## NOTE : the swimmer length ( sw_length ) is defined at the file run.sh

# in.vars #

in this file the following variables are defined:

Dimensions
- ndim = dimension of the simulation
- Lx, Ly  and Lz = simulation box dimensions

Smoothing lengths
# - h = kernel cutoff distance
- dx = distance between the particles

SPH variables
- sph_c = sound speed used in SPH calculations
- sph_rh0 = reference density in the SPH equation of state
- sph_rho = SPH density
- sph_eta = dinamic viscosity
- sph_mu = kinematic viscosity

Bond coeff parameters
- H_fene = potential at minimum
- r0_fene = maximum bond distance

Timestep and run parameters
- saver_freq = frequence when data is saved in dump file
- n step = number of timesteps

Atom types
- atom_type_solvent = set atom type to the solvent
- atom_type_sw_rest = set atom type to the other parts swimmer
- atom_type_sw_surface_head = set atom type to the head surface

Bond types numbering ( the same as in addswimmer.awk)
 - bond_strong = 1
 - bond_passive = 2
 - bond_head_flesh = 3

# in.geinit #

Creates initial grid with box and particles inside it

* atom_style   hybrid meso bond
  - A hybrid atom style is necessary to distinguish the atoms of the solvent
(meso) and the atoms of the swimmer (bond) 

* create_box   3
  - Three types of atomsin the simulation: solvent (1), surface of the swimmer
 head (3), the rest of the swimmer (2)

* mass         * 1
  - Set initial mass which is changes in "in.run"

* write_data   data.grid
  - Creates a file with Lammps style, including initial grid information

# addswimmer.awk #

Add one or more swimmers into the simulation and define the swimmer profile.

* function     xy2id

 - Transforms [x, y] coordinates to id of the atom

Variables:
    
- n_swimmer = number of swimmers to be included in the simulation
  ## NOTE: for each swimmer, one function 'create_swimmer()' must be included,
     with the variables sw_x_start and sw_y_start , in the end of the file.

- sw_start_x and sw_start_y = start position of the swimmer in x- and y-
  directions
  ## NOTE: those values are defined for the first swimmer and will be redefined
     for each swimmer.

- sw_tail_length = length of the tail of the swimmer ( 2/9 of the total swimmer
  length)

- sw_head_length = length of the swimmer head

* function    is_on_grid

  - Function used to delete corner atoms from the square grid created in the
    head, giving a different profile to the head.
    ## NOTE : in the a head in a square format is desired, all the 'if'
       conditional functions should be cancelled.

* function    bond_filter 

  - Add filters to change configurations of the bonds in the swimmer head.

* function    create_swimmer()
  - Assembles the functions to create the swimmer part by part and set bond
    parameters for each part

- After all definitions, create Swimmers and define start points in x- and
  y- directions, following the sequence for each swimmer:
      -  sw_start_y = ( starting point of the swimmer in y-direction)
      -  sw_start_x = (starting point of the swimmer in x-direction) 
      -  create_swimmer()  

# in.swimmer #

Define swimmers bond coefficients.

## NOTE: to use hamornic/swimmer bond_style it requires a custom version of
Lammps including the files 'bond_harmonic_swimmer.cpp' and 
'bond_harmonic_swimmer.h'.

For each swimmer, the following variables must be defined within this format:

variable        Umin* equal ${H_fene} # 
variable        req*  equal ${dx}
variable        rmax* equal ${r0_fene}
variable        A* equal 0.10*${dx}
variable        nA* equal -${A1}
variable        omega* equal 2*PI/${sw_length}
variable        phi* equal 0.0
variable        vel_sw* equal -0.01

## NOTE : the * symbol must de replaced by the swimmer number.

Variables definitions:

- Umin  = potential at minimum
- req = equilibrium bond distance
- rmax = maximum bond distance

Swimmer wave parameters A*sin(omega*N + phi - vel_sw*time):
- A = amplitude
- nA = negativ value of the amplitude
- omega = angular frequency
- phi = phase
- vel_sw = swimmer wave velocity

# - H_back = stiffness of the bond
- 'req_head_flesh' and 'Umin_head_flesh' are the parameters defined specially
for the head flesh

## NOTE : The variables 'H_fene', 'dx' and 'r0_fene' are defined at 'in.vars'
   file 
 
# in.run #

-In this file the SPH simulation parameters are set.

-The SPH coefficients are defined in the 'in.vars' file and set here in
 'pair_style' and 'pair_coeff'.

-The timestep is defined at 'settimestep.lmp' and here included.

-The dump files containing the output data are settled as data file and also as 
image outputs. The configuration of the output can be here modified with the user
requirements.

# run.sh #

- In this file the swimmer length (sw_length) is defined.

- From this executable file, the simulation is performed.

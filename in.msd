# move two atoms with DPD
include in.minsetup
comm_modify   vel yes

create_atoms 1 single 5.0 5.0 5.0 units box
create_atoms 1 single 5.5 5.0 5.0 units box

variable        T equal 0.0
variable        cutoff equal 1.0
variable        gamma  equal 1.0
variable        adpd equal 1.0

pair_style	dpd ${T} ${cutoff} 928948
pair_coeff	* * ${adpd} ${gamma} 1.0

compute         imsd all msd
variable        vmsd_x equal c_imsd[1]
variable        physical_time   equal dt*step
fix             pmsd all   print 1 "${physical_time} ${vmsd_x}" file "msd.dat" screen no

fix	        1 all nve
neighbor	5.0 bin
neigh_modify    delay 0 every 1
timestep        1e-3

run 1000
print           "output was writen to msd.dat file"

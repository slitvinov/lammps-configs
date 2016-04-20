#!/bin/bash

set -eux

default_dir=lammps-configs
rname=T_0.125_gx_3.90625e-4_timestep_0.005

# remote host name
host=brutus
rhost=$host

base=resolution
rpath='$SCRATCH'/SYNC/$base/$rname

deploy/gcp/gcp "${default_dir}" "${rhost}":"${rpath}"

# execute command remotely with <gitroot> as a current directory
rt () {
    ssh "${rhost}" "cd ${rpath}/${default_dir} ; cd object-around-cylinder ;" "$@"
}

#rt local/panda_dbg/setup.sh
#rt local/$host/setup.sh

rt local/brutus/setupt.sh

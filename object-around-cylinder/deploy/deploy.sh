#!/bin/bash

set -eux

default_dir=lammps-configs
rname=T_0.125_gx_9.765625e-4_timestep_0.0025

# remote host name
host=brutus
rhost=$host

base=zero
rpath='$SCRATCH'/SYNC/$base/$rname

deploy/gcp/gcp "${default_dir}" "${rhost}":"${rpath}"

# execute command remotely with <gitroot> as a current directory
rt () {
    ssh "${rhost}" "cd ${rpath}/${default_dir} ; cd object-around-cylinder ;" "$@"
}

#rt local/panda_dbg/setup.sh
#rt local/$host/setup.sh

rt local/brutus/setup.sh

#!/bin/bash

set -eux

default_dir=lammps-configs
rname=preved

# remote host name
host=brutus
rhost=$host

base=resolution
rpath='$SCRATCH'/SYNC/$base/$rname

deploy/gcp/gcp "${default_dir}" "${rhost}":"${rpath}"

# execute command remotely with <gitroot> as a current directory
rt () {
    ssh "${rhost}" "cd ${rpath}/${default_dir} ; cd object-around-cylinder ; $@"
}

#rt local/panda_dbg/setup.sh
#rt local/$host/setup.sh

rt local/brutus/setup.sh

#!/bin/bash

set -eux

. local/osx/vars.sh
. local/osx/utils.sh

default_dir=lammps-configs
rname=test

# remote host name
host=brutus
rhost=$host

base=ellipse
rpath='$SCRATCH'/SYNC/$base/$rname

# execute command remotely with <gitroot> as a current directory
rt () {
    ssh "${rhost}" "cd ${rpath}/${default_dir} ; cd dpd-simple-shear ;" "$@"
}

#deploy/gcp/gcp "${default_dir}" "${rhost}":"${rpath}"
rt local/$host/setup.sh

#!/bin/bash

set -eux

. local/brutus/vars.sh

default_dir=lammps-configs
rname=sc_${sc}_gx_${gx0}_nd_${nd}_xc_${xc}

# remote host name
host=brutus
rhost=$host

base=bem_faster
rpath='$SCRATCH'/SYNC/$base/$rname

deploy/gcp/gcp "${default_dir}" "${rhost}":"${rpath}"

# execute command remotely with <gitroot> as a current directory
rt () {
    ssh "${rhost}" "cd ${rpath}/${default_dir} ; cd object-around-cylinder ;" "$@"
}

#rt local/panda_dbg/setup.sh
rt local/$host/setup.sh

#!/bin/bash

set -eu
. local/osx/vars.sh
. local/osx/utils.sh

mpirun -n $np lmp $vars -in in.pre
mpirun -n $np lmp $vars -in in.dpd

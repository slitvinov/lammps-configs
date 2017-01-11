#!/bin/bash

set -eu
. local/osx/vars.sh
. local/osx/utils.sh

local/osx/pre.sh
# mpirun -n $np lmp $vars -in in.dpd
lmp $vars -in in.dpd

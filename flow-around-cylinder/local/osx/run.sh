#!/bin/bash

. local/osx/vars.sh
. local/osx/utils.sh

mpirun -n $np lmp $vars -in in.dpd

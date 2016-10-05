#!/bin/bash

# Fetch lammps source code
set -eu

. local/osx/vars.sh
. local/osx/utils.sh

cd $HOME/src
rm -rf $lmp_dir
git clone --depth 1 https://github.com/lammps/lammps $lmp_dir

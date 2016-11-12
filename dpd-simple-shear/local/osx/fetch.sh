#!/bin/bash

# Fetch lammps source code
set -eux

. local/osx/vars.sh
. local/osx/utils.sh

cd $HOME/src
rm -rf "$lmp_dir"
git clone --branch rigid --depth 1 "$lmp_repo" "$lmp_dir"

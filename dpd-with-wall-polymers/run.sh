#! /bin/bash

set -e
set -u

/scratch/work/lammps-ro/tools/chain2/src/chain2 -i in.generator -o chain.in -d def.chain  -echo both --verbose
../../src/lmp_linux -in in.fedosov

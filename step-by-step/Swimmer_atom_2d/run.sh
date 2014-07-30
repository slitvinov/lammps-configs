#!/bin/bash

# http://stackoverflow.com/a/6930607
# make the script fail on error
set -e
set -u

# the length of the swimmer
sw_length=4

# generate grid
./lmp_linux -var sw_length ${sw_length} -in in.geninit

# create bonds for the swimmer
awk -v sw_length=${sw_length} -f addswimmer.awk data.grid > data.bond

# make all atoms of the swimmer of the type `new_type'
awk -v new_type=2 -f change_type_of_bonded.awk  data.bond data.bond > data.polymer

./lmp_linux -var sw_length ${sw_length} -in in.run

#!/bin/bash

. local/brutus/vars.sh
. local/brutus/utils.sh
. local/brutus/module.sh

lmp -in in.pre
scripts/parse3d.awk pre/pre.data.out > pre/pre.data.in

lmp -in in.dpd

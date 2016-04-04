#!/bin/bash

set -eux

lmp -in in.pre
#scripts/parse0.awk pre/pre.data.out > pre/pre.data.in

scripts/parse3d.awk pre/pre.data.out > pre/pre.data.in
lmp -in in.dpd

#!/bin/bash

lmp -in in.pre

scripts/parse0.awk pre/pre.data.out > pre/pre.data.in

lmp -in in.dpd

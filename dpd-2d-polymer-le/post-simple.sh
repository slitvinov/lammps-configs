#! /bin/bash

set -e
set -u


awk 'flag{print $4, $5, $6} /Atoms/{flag=1; getline}' \
    $* > punto.dat



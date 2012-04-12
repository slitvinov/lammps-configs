#! /bin/bash

set -e
set -u

parallel -a polymer-in-trap/kst.in -N1 --verbose polymer-in-trap/runone.sh {1}

#!/bin/bash

. local/brutus/vars.sh

set -x

local/brutus/compile.sh
local/brutus/pre.sh
local/brutus/run.sh

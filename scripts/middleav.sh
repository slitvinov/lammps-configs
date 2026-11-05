#! /bin/bash
mp=$(awk 'NF==2{s++} END{print s/2.0}' "$1")

awk -v mp=${mp} 'n>mp+1{exit}; NF==2{n++; next}; n>mp' "$1"

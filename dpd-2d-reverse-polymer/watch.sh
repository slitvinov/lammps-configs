#!/bin/bash

ls -d D100*noforce3D* | xargs -n1 bash post-hist.sh

gnuplot <<EOF
set term dumb
set key bottom
set style data line
plot [0:0.6] \
     "D100noforce3D~gx~2.0/m-shifted.dat", \
     "D100noforce3D~gx~1.0/m-shifted.dat"
call "saver.gp" "watch"
EOF

cp watch.png ~/Dropbox/Public/

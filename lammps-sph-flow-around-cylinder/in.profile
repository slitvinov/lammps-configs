# function to get profile
region rvareg${crossid} block INF INF ${yposlo} ${yposhi} INF INF units box
compute chunk_av_vy${crossid} all chunk/atom bin/1d x center 1.0 region rvareg${crossid}
fix av_vy${crossid} all ave/chunk 1 ${Nrepeat} ${Nfreq} chunk_av_vy${crossid} vy file vy.av.${crossid}

# function to get profile
region rvareg${crossid} block INF INF ${yposlo} ${yposhi} INF INF units box
fix av_vy${crossid} all ave/spatial 1 ${Nrepeat} ${Nfreq} x center 0.25 vy file vy.av.${crossid} region rvareg${crossid}

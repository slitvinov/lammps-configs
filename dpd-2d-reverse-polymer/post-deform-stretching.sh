#! /bin/bash

set -e
set -u

for R in $(./genid.sh  list=R); do
    for stfx in $(./genid.sh  list=stfx); do
	id=$(./genid.sh R=${R} stfx=${stfx})
	if [ -f ${id}/vx.av ]; then
	    ../scritps/lasvav.sh ${id}/sxy.av  > /tmp/vel
	    sxy=$(./fitvx.sh /tmp/vel ${id}/sx | awk '{print $2}')
	    ../scritps/lasvav.sh ${id}/vx.av  > /tmp/vel
	    gamma=$(./fitvx.sh /tmp/vel ${id}/vx | awk '{print $1}')
	    echo ${R} ${stfx} ${sxy} ${gamma}
	fi
    done
done

	

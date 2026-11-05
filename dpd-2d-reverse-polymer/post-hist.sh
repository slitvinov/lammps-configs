#! /bin/bash


dname=$1
for x in $(seq 0.005 0.01 1.0); do
    ../scripts/lasvav.sh ${dname}/vx.av.hist | awk -v c=${x} '$2==c{print $3, $5}' | \
	awk 'NF{y[n++]=$2; x[n]=$1; s+=$2} END { for (i=0; i<n; i++) {if (y[i]>0) {print x[i], y[i]/s}}}' > ${dname}/prof.x${x}
    m=$(bash fitm.sh ${dname}/prof.x${x})

    vmax=$(../scripts/lasvav.sh ${dname}/vx.av.hist | awk -v c=${x} '$2==c{print $3, $5}' | \
	awk '$2>s{s=$2} END{print s}')
    ../scripts/lasvav.sh ${dname}/vx.av.hist | awk -v c=${x} '$2==c{print $3, $5}' > ${dname}/vx.x${x}
    echo ${x} ${m} ${vmax}

    ../scripts/lasvav.sh ${dname}/polymer.ndensity.hist | awk -v c=${x} '$2==c{print $3, $5}' > ${dname}/polymer.x${x}
    ../scripts/lasvav.sh ${dname}/sxy-bond.hist | awk -v c=${x} '$2==c{print $3, $5}' > ${dname}/bond.x${x}
done > ${dname}/m.dat

echo $* | xargs -n1 ./shift.sh

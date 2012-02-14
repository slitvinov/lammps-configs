#! /bin/bash
# add polymer to the dump data file
set -e
set -u

varlist="input output polyidfile cutoff Nbeads Nsolvent Npoly"
# returns true if "$1" is a variable name defined in varlist (see genid_def.sh)
function findvar() {
    local name="$1"
    local var
    for var in ${varlist}; do
	if [ ${var} == "${name}" ]; then
	    return 0
	fi
    done
    return 1
}


function readinputargs () {
    local i aux_val aux_name
    for i in $*
    do
	if [[ ! "$i" == *=* ]]; then
	    printf "($0) parameter is not in A=val form: %s\n" "${i}" > "/dev/stderr"	    
	    exit
	fi
	    
	aux_name=${i%=*}
	aux_val=${i#*=}
	if (! findvar ${aux_name} ) then
	    printf "($0) unknown variable name: %s\n" ${aux_name} > "/dev/stderr"
	    exit -1
	fi
	eval "${aux_name}=${aux_val}"	
    done
}

readinputargs $*
restart2data=/scratch/work/lammps-ro/tools/restart2data
aux1file=$(mktemp)
aux2file=$(mktemp)

${restart2data} ${input} ${aux1file}
awk -v cutoff=3.0 -v Nbeads=15 -v Nsolvent=15 -v Npoly=full \
    -v polyidfile=${polyidfile} \
    -f addpolymer.awk ${aux1file} > ${aux2file}
nbound=$(tail -n 1 ${aux2file} | awk '{print $1}')
sed -i "s/_NUMBER_OF_BOUNDS_/$nbound/1" ${aux2file}

awk -v polymer_type=3 -f addmolnumber.awk \
    -v polyidfile=${polyidfile} \
    ${aux2file} > ${aux1file}

mv ${aux1file} ${output}
rm ${aux2file}

#! /bin/bash

function setdefault() {
    for var in ${varlist}; do
	eval "$var=all"
    done
}

function genid() {
    lprefix=${prefix}
    local var
    for var in ${varlist}; do
	lprefix=$(genseq ${var} ${!var} ${lprefix})
    done
    echo $(addsuffix ${lprefix})
}

function genseq() {
    local varname="$1"
    local key="$2"
    local varlist=${varname}_list 
    shift 2
    for prefix in $*; do
	case ${key} in
	    all)
		# add all values
		for val in ${!varlist} ; do
		    echo ${prefix}${FS}${varname}${NS}${val}
		done
		;;
	    null)
		# just reprint prefix
		echo ${prefix}
		;;
	    *)
		# add one value
		echo ${prefix}${FS}${varname}${NS}${key}
	esac
    done
}

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

function isvalidval() {
    local name="$1"
    local val="$2"
    local vallist=${name}_list
    local v
    for v in ${!vallist} ${specialval} ; do
	if [ ${v} == "${val}" ]; then
	    return 0
	fi
    done
    return 1
}

function addsuffix() {
    local pre
    for pre in $*; do
	if [ "${suffix}" == "" ]; then
	    echo ${pre}
	elif [ "${prefix}" == "${pre}" ]; then
	    echo ${pre}${suffix}
	else
	    echo ${pre}${FS}${suffix}
	fi
    done
}

function getvallist () {
    local name="$1"
    local vallist=${name}_list
    echo ${!vallist}
 }



function readinputargs () {
    local i aux_val aux_name
    for i in $*
    do
	if [[ ! "$i" == *=* ]]; then
	    printf "(genid.sh) parameter is not in A=val form: %s\n" "${i}" > "/dev/stderr"	    
	    exit
	fi
	    
	aux_name=${i%=*}
	aux_val=${i#*=}
	if [ "${aux_name}" == "p" ]; then
	    prefix=${aux_val}
	elif [ "${aux_name}" == "s" ]; then
	    suffix=${aux_val}
	elif [ "${aux_name}" == "cvv" ]; then
	    CHECK_VALID_VAL=${aux_val}
	elif [ "${aux_name}" == "list" ]; then
	    if (! findvar ${aux_val} ) then
		printf "(genid.sh) unknown variable name: %s\n" ${aux_val} > "/dev/stderr"
		exit -1
	    fi
	    local vallist=${aux_val}_list
	    printf "%s\n" ${!vallist}
	    exit 0
	elif [ "${aux_name}" == "varlist" ]; then
	    printf "%s\n" ${varlist}
	    exit 0
	else
	    if (! findvar ${aux_name} ) then
		printf "(genid.sh) unknown variable name: %s\n" ${aux_name} > "/dev/stderr"
		exit -1
	    fi
	    if [[ "${CHECK_VALID_VAL}" == 1 ]]; then
		if (! isvalidval ${aux_name} ${aux_val}) then
		    printf "(genid.sh) value %s is not valid for variable %s\n" ${aux_val} ${aux_name} > "/dev/stderr"
		    printf "(genid.sh) possible values are: %s\n" "$(getvallist ${aux_name}) ${specialval}" > "/dev/stderr"
		    exit -1
		fi
	    fi
	    eval "${aux_name}=${aux_val}"	
	fi
    done
}

specialval="null all"
source genid_def.sh

setdefault
readinputargs $*
genid


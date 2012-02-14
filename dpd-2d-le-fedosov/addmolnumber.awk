#!/usr/bin/awk -f

BEGIN {
    if (length(polyidfile)==0) {
	polyidfile="poly.id"
    }

    if (length(polymertype)==0) {
	# default value of polymer type
	polymertype=3
    }
    
    # read ids from poly.id file
    while (getline line < polyidfile > 0) {
	split(line, a, " ");
	# global id of the atom
	id=a[1]
	# polymer id
	pid=a[2]
	# map global id to polymer
	phash[id]=pid
    }
}

(NF>0)&&($1=="Atoms"){
  inatoms=1
  print
  # skip empty line
  getline
  printf "\n"
  next
}

inatoms && (NF==0) {
  inatoms = 0
  print
  next
}

inatoms {
    id=$1
    if (id in phash) {
	$2 = phash[id]
	$3=polymer_type
    }
    print $0
    next
}

!inatoms {
  print
  next
}

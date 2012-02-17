#!/usr/bin/awk -f
function fabs(var) {
  return var>0?var:-var
}

function isbound(atom_number,        period, rem, current_npoly) {
  period = Nbeads + Nsolvent
  rem = (atom_number-1)%(period) # from 0 to period-1
  current_npoly = int(atom_number/period) + 1
  return (rem<Nbeads-1) && (atom_number<iatom)  && (current_npoly<=Npoly)
}

BEGIN {
    if (length(polyidfile)==0) {
	polyidfile="poly.id"
    }
  inatoms=0
  lo=1; hi=2
  x=1; y=2; z=3
  iatom=0
  if (Npoly=="full") {
    Npoly = 1e22
  }
}

/LAMMPS/{
  print
  next
}

/xlo xhi/{
  box[x,lo]=$1
  box[x,hi]=$1
}

/ylo yhi/{
  box[y,lo]=$1
  box[y,hi]=$2
}

/zlo zhi/{
  box[z,lo]=$1
  box[z,hi]=$2
}

/atom types/{
  print
  print "1 bond types"
  if (addangle) {
      print "1 angle types"
  }
  next
}

/atoms/{
  natoms=$1
  print
  printf("%s bonds\n", "_NUMBER_OF_BOUNDS_")
  if (addangle) {
      printf("%s angles\n", "_NUMBER_OF_ANGLES_")
  }
  next
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

inatoms{
 # here I get one atom
  iatom++
  R[x]=$4; R[y]=$5; R[z]=$6
  if (iatom>1) {
    for (idim=1; idim<=3; idim++) {
      if (fabs(R[idim]- prevR[idim])>cutoff) {
        if (R[idim]<prevR[idim]) image[idim]++; else image[idim]--
      }
    }
  } else {
    image[x]=0; image[y]=0; image[z]=0
  }
  prevR[x]=R[x]; prevR[y]=R[y]; prevR[z]=R[z]
  # change image field
  $(NF-2)=image[x]; $(NF-1)=image[y];   $(NF)=image[z];
  # add molecule ID
 # $6=$6 " 0"
  print $0
  next
}

!inatoms {
  print
  next
}

END {
  printf("\nBonds\n\n")
  ibond = 0
  ipoly=0
  printf("") > polyidfile
  for (q=1; q<iatom; q++) {
    if (isbound(q)) {
      ibond++
      ip = q
      jp = q+1
      bondtype=1
      print ibond, bondtype, ip, jp
      if (ip != prev) {
	  ipoly++
      }
      print ip, ipoly >> polyidfile
      poly_hash[ip]=1
      if (!(jp in poly_hash)) { 
	  print jp, ipoly >> polyidfile
	  poly_hash[jp]=1
      }
      prev=jp    
    }
  }


 # Angle section
 if (addangle>0) {
  angletype=1
  printf("\nAngles\n\n")
  iangle = 0
  for (q=1; q<iatom; q++) {
      if (isbound(q+1)&&isbound(q)) {
	  iangle++
	  ia = q
	  ja = q+1
	  ka = q+2
	  # number of angle, type of angle, three atoms to form an angle
	  print iangle, angletype, ia, ja, ka
      }
  }
 }
}

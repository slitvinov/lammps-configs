#!/usr/bin/awk -f

flag && NF>2  {
    if ($3<$4)     s-=$2; else s+=$2
    id_set[$3,$4]=42
} 

/^ITEM: ENTRIES/ {
    flag=1
}


function output() {
    print s
    flag=s=0
    delete id_set
}

FNR==1 {
    output()
}

END {
    output()
}

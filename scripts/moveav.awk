#!/usr/bin/awk -f
BEGIN{
    if (length(size)==0) {
	size=5
    }
} 

{
    mod=NR%size
    if(NR<=size){count++} else {sum-=array[mod]}
    sum+=$1
    array[mod]=$1
    print sum/count
}
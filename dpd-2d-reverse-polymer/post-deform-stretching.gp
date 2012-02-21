set log
plot \
     "<awk '$2==0' hm" u 1:($3/$1) w lp, \
     "<awk '$2==10' hm" u 1:($3/$1) w lp, \
     "<awk '$2==50' hm" u 1:($3/$1) w lp, \
     "<awk '$2==100' hm" u 1:($3/$1) w lp, \
     "<awk '$2==150' hm" u 1:($3/$1) w lp, \
     "<awk '$2==200' hm" u 1:($3/$1) w lp

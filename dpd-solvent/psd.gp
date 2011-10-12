plot [-9:]\
     "output.dat" u (log($1)):(log($2)),  \
     "" u (log($1)):(log($2)) smooth kdensity w lp
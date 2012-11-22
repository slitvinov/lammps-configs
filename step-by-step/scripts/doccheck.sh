#! /bin/bash

# check if a file is mentioned in the README.org
flist=$(ls -1 *.*)

printf "not found in documentation:\n"

for file in ${flist}; do
    grep -q $file README.org
    if [ ! $? -eq 0 ]; then
	printf "%s\n" ${file}
    fi
done


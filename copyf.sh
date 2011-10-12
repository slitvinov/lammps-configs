#! /bin/bash

dname=$1
cp ${dname}/in.* .
cp ${dname}/*.sh .
cp ${dname}/*.gp .
cp ${dname}/*.awk .
cp ${dname}/def.chain .
rm *~

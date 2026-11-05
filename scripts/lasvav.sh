#! /bin/bash


tac "$1" | awk 'NF==2{f=1} !f' 

#!/bin/bash
# Author: David Bridgwood dmb2417@ic.ac.u
# Script: ConcatenateTwoFiles.sh
# Desc: Concatinate two files $1 and $2 and write to new file $3
# Arguments: none
# Date: Oct 2017

cat $1 > $3 
cat $2 >> $3
echo "Merged file is" 
cat $3


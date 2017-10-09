#!/bin/bash
# Author: David Bridgwood dmb2417@ic.ac.uk                                      
# Script: CountLines.sh                                                        
# Desc: Counts the number of lines in a file $1 
# Arguments: none                                                               
# Date: Oct 2017 


NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"
echo

#!/bin/bash
# Author: David Bridgwood dmb2417@ic.ac.uk
# Script: csvtospace.sh
# Desc: create a space seperated version of a csv file $1
# Arguments: none
# Date: Oct 2017

echo "Creating a Space seperated version of $1 ..."

cat $1 | tr -s "," " " > $1.txt

echo "Done!"

#!/bin/bash

echo "Creating a Space seperated version of $1 ..."

cat $1 | tr -s "," " " > $1.txt

echo "Done!"

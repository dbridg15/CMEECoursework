#!/usr/bin/env bash
# Author: David Bridgwood dmb2417@ic.ac.uk
# Script: run_LV.sh
# Desc: runs  and profiles LV1.py and LV2.py


python -m cProfile LV1.py > tmp.txt

echo LV1.py
head -n 1 tmp.txt
echo

python -m cProfile LV2.py > tmp.txt

echo LV2.py
head -n 1 tmp.txt
echo

rm tmp.txt

#!usr/bin/env Rscript

# script: next.R
# Desc: using next to skip iterations of loop
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# required packages

###############################################################################
# 8.2.2 using next
###############################################################################

for(i in 1:10){
    if((i %% 2) == 0)
        next  # pass to next iteration of the loop
    print(i)
}

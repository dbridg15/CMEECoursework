#!usr/bin/env Rscript

# script: apply1.R
# Desc: applying the same function to rows/columns of a matrix
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

###############################################################################
# 8.1.1 The *apply family of functions part1
###############################################################################
# apply: applying the same function to rows/columns of a matrix

# build a random matrix
M <- matrix(rnorm(100), 10, 10)

# take the mean of each row
RowMeans <- apply(M, 1, mean)
print(RowMeans)

# now the varience
RowVars <- apply(M, 1, var)
print(RowVars)

# and by column
ColMeans <- apply(M, 2, mean)
print(ColMeans)

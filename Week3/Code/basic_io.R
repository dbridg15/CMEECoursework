#!usr/bin/env Rscript

# script: basic_io.R
# Desc: A simple R script to illustrate R input and Output
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# required packages

###############################################################################
# 7.12 Writing R code, input and output
###############################################################################

# Import with headers
MyData <- read.csv("../Data/trees.csv", header = TRUE)

# Write out to a new file
write.csv(MyData, "../Results/MyData.csv")

# Append to it gives an error cause its a stupid thing to do!!
write.table(MyData[1,], file = "../Results/MyData.csv", append = TRUE)

# Write row names
write.csv(MyData, "../Results/MyData.csv", row.names = TRUE)

# ignore column names
write.table(MyData, "../Results/MyData.csv", col.names = FALSE)

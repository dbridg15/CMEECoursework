#!usr/bin/env Rscript

# script: GPDD_maps.R
# Desc: inserts points from global data onto a world map
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# required packages

require(maps)

###############################################################################
# maps in R
###############################################################################

load("../Data/GPDDFiltered.RData")


map("world", fill=TRUE, col="white", bg="lightblue")
points(x=gpdd$long, y=gpdd$lat, col = gpdd$common.name , pch = 19, cex= 0.5)
# dont understand why long is x and lat is y???? but the other way looks all
# wrong!!!

# Data is biased to North America and Western Europe!

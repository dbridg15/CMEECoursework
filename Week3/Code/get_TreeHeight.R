#!/usr/bin/env R

# This function calculates heights of trees from the angle
# elevation and the distance from the base using the trigonometric
# formula: height = distance * tan(radians)
#
# ARGUMENTS:
# degrees         The angle of elevation
# distance        The distance from the base
#
# OUTPUT:
# The height of the tree, same units as "distance"  

args <- commandArgs(trailingOnly = TRUE)

args <- "../Data/trees.csv"
Trees <- read.csv(args[1])

TreeHeight <- function(degrees, distance){
  radians <- degrees * pi / 180
  height <- distance * tan(radians)
#  print(paste("Tree height is:", height))
  
  return(height)
}


Trees$Tree.m.height <- TreeHeight(Trees$Angle.degrees, Trees$Distance.m)

Trees

outfile <- paste("../Results/", strsplit(basename(args[1]), ".csv"), "_treeheights.csv", sep = "")
  

write.csv(Trees, outfile, row.names = FALSE)

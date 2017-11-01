#!usr/bin/env Rscript

# script: get_TreeHeight.R
# Desc: calculates heigfht of tree from angle of elevation and distance
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# required packages

###############################################################################
# get_TreeHeight.R
###############################################################################

# This script takes in a given csv fike from the command line
# calculates heights of trees from the angle
# elevation and the distance from the base using the trigonometric
# formula: height = distance * tan(radians)
#
# ARGUMENTS:
#       degrees     The angle of elevation
#       distance    The distance from the base
#
# OUTPUT:
#       The height of the tree, same units as "distance"


# commandArgs reads in the arguments given in the command line
args <- commandArgs(trailingOnly = TRUE)

Trees <- read.csv(args[1])

# define function
TreeHeight <- function(degrees, distance){
    radians <- degrees * pi / 180
    height <- distance * tan(radians)

    return(height)
}

# add heights as new column
Trees$Tree.m.height <- TreeHeight(Trees$Angle.degrees, Trees$Distance.m)

# write to file
# basename removes the directory, strsplit removes the .csv
outfile <- paste("../Results/", strsplit(basename(args[1]), ".csv"),
                 "_treeheights.csv", sep = "")


write.csv(Trees, outfile, row.names = FALSE)

###############################################################################
# TreeHeight.R
###############################################################################
# This function calculates heights of trees from the angle
# elevation and the distance from the base using the trigonometric
#
# formula: height = distance * tan(radians)
#
# ARGUMENTS:
#       degrees     The angle of elevation
#       distance    The distance from the base
#
# OUTPUT:
#       The height of the tree, same units as "distance"


# Read in csv file to Trees as dataframe
Trees <- read.csv("../Data/trees.csv")

TreeHeight <- function(degrees, distance){
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    return(height)
}


# Add new column Tree.m.height to Trees dataframe
Trees$Tree.m.height <- TreeHeight(Trees$Angle.degrees, Trees$Distance.m)

head(Trees)

# Write to csv
write.csv(Trees, "../Results/TreeHts.csv", row.names = FALSE)

# Remove all objects
rm(list = ls())

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

Trees <- read.csv("../Data/trees.csv")

TreeHeight <- function(degrees, distance){
  radians <- degrees * pi / 180
  height <- distance * tan(radians)
#  print(paste("Tree height is:", height))
  
  return(height)
}

Trees$Tree.m.height <- TreeHeight(Trees$Angle.degrees, Trees$Distance.m)

Trees

write.csv(Trees, "../Results/TreeHts.csv", row.names = FALSE)

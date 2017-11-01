#!usr/bin/env Rscript

# script: PP_Lattice.R
# Desc: produces 3 lattice plots split by type of feeding interaction and
# writes a csv file containing the results
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# required packages
require('lattice')
require('ggplot2')
require('dplyr')

###############################################################################
# PP_Lattice.R
###############################################################################

MyDF <- read.csv('../Data/EcolArchives-E089-51-D1.csv')

# for loop to convert mg to g and save in new column
for(i in 1:length(MyDF$Record.number)){
        if(MyDF$Prey.mass.unit[i] == "mg"){
            MyDF$Prey.mass.g[i] = (MyDF$Prey.mass[i]/1000)
        }
        else{
            MyDF$Prey.mass.g[i] = MyDF$Prey.mass[i]
        }
}

# predator lattice
pdf("../Results/Pred_Lattice.pdf")
densityplot(~log(Predator.mass) | Type.of.feeding.interaction,
            data = MyDF)
dev.off()

# prey lattice
pdf("../Results/Prey_Lattice.pdf")
densityplot(~log(Prey.mass.g) | Type.of.feeding.interaction,
            data = MyDF)
dev.off()

# Size Ratio lattice
pdf("../Results/SizeRatio_Lattice.pdf")
densityplot(~log(Prey.mass.g/Predator.mass) | Type.of.feeding.interaction,
      data = MyDF)
dev.off()

# making results
results <- MyDF %>%
    group_by(Type.of.feeding.interaction) %>%
    summarise(mean_pred = mean(log(Predator.mass)),
              mean_prey = mean(log(Prey.mass.g)),
              mean_size_ratio = mean(log(Prey.mass.g/Predator.mass)),
              meadian_pred = median(log(Predator.mass)),
              median_prey = median(log(Prey.mass.g)),
              median_size_ratio = median(log(Prey.mass.g/Predator.mass)))

# give the headers nicer names
headers <- c("Type_of_Feeding Interaction",
             "Mean_of_log(Predator Mass)",
             "Mean_of_log(Prey Mass)",
             "Mean_of_log(Size Ratio)",
             "Median_of_log(Predator Mass)",
             "Median_of_log(Prey Mass)",
             "Median_of_log(Size Ratio)")
names(results) <- headers

write.csv(results, "../Results/PP_Results.csv", row.names = F)

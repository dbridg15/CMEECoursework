rm(list = ls())

###############################################################################
# PP_Lattice.R
###############################################################################

require('lattice')
require('ggplot2')
require('dplyr')

MyDF <- read.csv('../Data/EcolArchives-E089-51-D1.csv')


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
pdf("SizeRatio_Lattice.pdf")
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

headers <- c("Type_of_Feeding Interaction",
             "Mean_of_log(Predator Mass)",
             "Mean_of_log(Prey Mass)",
             "Mean_of_log(Size Ratio)",
             "Median_of_log(Predator Mass)",
             "Median_of_log(Prey Mass)",
             "Median_of_log(Size Ratio)")

names(results) <- headers

write.csv(results, "../Results/PP_Results.csv", row.names = F)
results

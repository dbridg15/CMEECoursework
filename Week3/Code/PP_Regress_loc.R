#!usr/bin/env Rscript

# script: PP_Regress_loc.R
# Desc: produces csv file of linear models statistics grouped by type of
# feeding interaction, predator lifestage and location
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# required packages
require(plyr)


###############################################################################
# sorting out the data-frame
###############################################################################

MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")

# convert mg to grams
for(i in 1:length(MyDF$Record.number)){
        if(MyDF$Prey.mass.unit[i] == "mg"){
            MyDF$Prey.mass.g[i] = (MyDF$Prey.mass[i]/1000)
        }
        else{
            MyDF$Prey.mass.g[i] = MyDF$Prey.mass[i]
        }
}


###############################################################################
# getting the stats for the lines!
###############################################################################

# dply to group data by feeding method and lifestage and store models
model <- dlply(MyDF, .(Type.of.feeding.interaction,
                       Predator.lifestage,
                       Location),
           function(x) lm(log(Predator.mass)~log(Prey.mass.g), data = x))

# pull out the stats from the model
results <- ldply(model, function(x) {r.sq <- summary(x)$r.squared
                           intercept <- summary(x)$coefficients[1]
                           slope <- summary(x)$coefficients[2]
                           p.val  <- summary(x)$coefficients[8]
                           data.frame(r.sq, intercept, slope, p.val)})

# f-statistic couldnt be calculated for 1 group and so caused error in ldply
f.stat <- ldply(model, function(x) summary(x)$fstatistic[1])

# merge f-statistic with the other results
results <- merge(results, f.stat, by = c("Type.of.feeding.interaction",
                                "Predator.lifestage", "Location"), all = T)

# give f-statistic a proper title
names(results)[8] <- "F.statistic"
# write to csv
write.csv(results, "../Results/PP_Regress_loc_results.csv")

rm(list = ls())
###############################################################################
# PP_Regress.R
###############################################################################

require(ggplot2)
require(dplyr)
require(plyr)

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
# making the chart!!
###############################################################################

# tried in q plot first, got most of the way!
# qplot(Prey.mass.g, Predator.mass,
#       facets = Type.of.feeding.interaction ~.,
#       data = MyDF,
#       colour = Predator.lifestage,
#       shape = I(3)) +
#       scale_x_log10() +
#       scale_y_log10() +
#       theme_bw() +
#       theme(legend.position = "bottom") +
#       geom_smooth(method = "lm", fullrange = T)
#

p <- ggplot(data = MyDF, aes(Prey.mass.g, Predator.mass,
                             colour = Predator.lifestage)) +
            geom_point(shape = I(3)) +  # set shape
            geom_smooth(method = "lm", fullrange = T) +  # add lm lines
            facet_grid(Type.of.feeding.interaction~.) +  # facet by feeding
            scale_x_log10() + scale_y_log10() +  # scale axis
            theme_bw() +
            theme(legend.position = 'bottom') +  # move legened to bottom
            guides(colour = guide_legend(nrow = 1)) +  # legend on 1 row
            xlab("Prey Mass in grams") +
            ylab("Predator Mass in grams") +
            coord_fixed(0.45) +  # fix ratio of plot so its not too fat
            theme(legend.title = element_text(face = "bold"))

# print p to pdf A4 page size
pdf("../Results/PP_Regress_figure.pdf", 8.3, 11.7)
    print(p)
dev.off()


###############################################################################
# getting the stats for the lines!
###############################################################################

model <- dlply(MyDF, .(Type.of.feeding.interaction, Predator.lifestage),
           function(x) lm(log(Predator.mass)~log(Prey.mass.g), data = x))

results <- ldply(model, function(x) {r.sq <- summary(x)$r.squared
                           intercept <- summary(x)$coefficients[1]
                           slope <- summary(x)$coefficients[2]
                           p.val  <- summary(x)$coefficients[8]
                           data.frame(r.sq, intercept, slope, p.val)})

f.stat <- ldply(model, function(x) summary(x)$fstatistic[1])

results <- merge(results, f.stat, by = c("Type.of.feeding.interaction",
                                "Predator.lifestage"), all = T)

names(results)[7] <- "F.statistic"

write.csv(results, "../Results/PP_Regress_results.csv")

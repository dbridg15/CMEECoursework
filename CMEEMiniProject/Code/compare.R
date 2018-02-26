#!usr/bin/env Rscript

# script:
# Desc:
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# imports
require(ggplot2)
require(tidyr)

###############################################################################
# read in data
###############################################################################

cubicDF <- read.csv("../Results/cubic_model.csv")
flschDF <- read.csv("../Results/full_scholfield_model.csv")
nhschDF <- read.csv("../Results/noh_scholfield_model.csv")
nlschDF <- read.csv("../Results/nol_scholfield_model.csv")
arrhnDF <- read.csv("../Results/arrhenius_model.csv")

aicdf <- data.frame("NewID" = cubicDF$NewID,
                    "cubic" = cubicDF$aic,
                    "flsch" = flschDF$aic,
                    "nhsch" = nhschDF$aic,
                    "nlsch" = nlschDF$aic)

###############################################################################
# calculate aic delta and weight for each model
###############################################################################

cubic_delta <- function(row){
  abs(min(row, na.rm = TRUE) - row["cubic"])
}

flsch_delta <- function(row){
  abs(min(row, na.rm = TRUE) - row["flsch"])
}

nhsch_delta <- function(row){
  abs(min(row, na.rm = TRUE) - row["nhsch"])
}

nlsch_delta <- function(row){
  abs(min(row, na.rm = TRUE) - row["nlsch"])
}

cubic_weight<- function(row){
  if (is.na(row["cubicd"])){
    0
  } else{
    exp(-.5*row["cubicd"])/sum(exp(-.5*row[c("cubicd", "flschd", "nhschd",
                                             "nlschd")]), na.rm = TRUE)
  }
}

flsch_weight <- function(row){
  if (is.na(row["flschd"])){
    0
  } else{
    exp(-.5*row["flschd"])/sum(exp(-.5*row[c("cubicd", "flschd", "nhschd",
                                             "nlschd")]), na.rm = TRUE)
  }
}

nhsch_weight <- function(row){
  if (is.na(row["nhschd"])){
     0
  } else{
    exp(-.5*row["nhschd"])/sum(exp(-.5*row[c("cubicd", "flschd", "nhschd",
                                             "nlschd")]), na.rm = TRUE)
  }
}

nlsch_weight <- function(row){
  if (is.na(row["nlschd"])){
    0
  } else{
    exp(-.5*row["nlschd"])/sum(exp(-.5*row[c("cubicd", "flschd", "nhschd",
                                             "nlschd")]), na.rm = TRUE)
  }


aicdf$cubicd <- apply(aicdf, 1, cubic_delta)
aicdf$flschd <- apply(aicdf, 1, flsch_delta)
aicdf$nhschd <- apply(aicdf, 1, nhsch_delta)
aicdf$nlschd <- apply(aicdf, 1, nlsch_delta)

aicdf$cubicw <- apply(aicdf, 1, cubic_weight)
aicdf$flschw <- apply(aicdf, 1, flsch_weight)
aicdf$nhschw <- apply(aicdf, 1, nhsch_weight)
aicdf$nlschw <- apply(aicdf, 1, nlsch_weight)

###############################################################################
# gather (try with tidyr if you get time!)
###############################################################################

df <- rbind.data.frame(
      cbind.data.frame(NewID = aicdf$NewID, model = "cubic", aic = aicdf$cubic,
                       delta = aicdf$cubicd, weight = aicdf$cubicw),
      cbind.data.frame(NewID = aicdf$NewID, model = "flsch", aic = aicdf$flsch,
                       delta = aicdf$flschd, weight = aicdf$flschw),
      cbind.data.frame(NewID = aicdf$NewID, model = "nhsch", aic = aicdf$nhsch,
                       delta = aicdf$nhschd, weight = aicdf$nhschw),
      cbind.data.frame(NewID = aicdf$NewID, model = "nlsch", aic = aicdf$nlsch,
                       delta = aicdf$nlschd, weight = aicdf$nlschw))

###############################################################################
# test plots
###############################################################################

ggplot(data = df[which(df$weight > 0),], aes(y = weight, x = model)) + geom_boxplot()

###############################################################################
#
###############################################################################

mod <- lm(weight ~ model, data = df)

summary(mod)
anova(mod)
confint(mod)




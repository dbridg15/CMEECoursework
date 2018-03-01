#!usr/bin/env Rscript

# script:
# Desc:
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())
# suppressPackageStartupMessages()
# imports
require(ggplot2)
require(tidyr)

start_time <- proc.time()

###############################################################################
# read in data
###############################################################################

cubicDF = read.csv("../Results/cubic_model.csv")
flschDF = read.csv("../Results/full_scholfield_model.csv")
nhschDF = read.csv("../Results/noh_scholfield_model.csv")
nlschDF = read.csv("../Results/nol_scholfield_model.csv")
arrhnDF = read.csv("../Results//arrhenius_model.csv")

aicdf = data.frame("NewID" = cubicDF$NewID,
                   "cubic" = cubicDF$nlaic,
                   "flsch" = flschDF$nlaic,
                   "nhsch" = nhschDF$nlaic,
                   "nlsch" = nlschDF$nlaic,
                   "arrhn" = arrhnDF$nlaic)

###############################################################################
# functions
###############################################################################


delta <- function(row, model){
  abs(min(row, na.rm = TRUE) - row[model])
}

weight <- function(row, model_delta, comparing){
  if (is.na(row[model_delta])){
    0
  } else {
    exp(-.5*row[model_delta])/sum(exp(-.5*row[comparing]), na.rm = TRUE)
  }
}

compare <- function(models){

  DFaic    <- paste0(models, "DF$nlaic")
  DFdelta  <- paste0(models, "_delta")
  DFweight <- paste0(models, "_weight")
  DFpass   <- paste0(models, "_pass")


  aicDF <- data.frame("NewID" = eval(parse(text = (paste0(models[1], "DF$NewID")))))

  for (i in 1:length(models)){
    aicDF <- cbind(aicDF, eval(parse(text = DFaic[i])))
  }

  colnames(aicDF) <- c("NewID", models)

  for (i in 1:length(models)){
    aicDF[DFdelta[i]] <- apply(aicDF, 1, delta, model = models[i])
  }

  for (i in 1:length(models)){
    aicDF[DFweight[i]] <- apply(aicDF, 1, weight, model_delta = DFdelta[i],
                                comparing = DFdelta)
  }

  for (i in 1:length(models)){
    aicDF[DFpass[i]] <- eval(parse(text = (paste0("aicDF$", DFdelta[i])))) <= 2
  }

  cat("\nBased off of delta when < 2 from minimum aic means models are comparable\n\n")

  for (i in 1: length(models)){
    passed <- sum(eval(parse(text = (paste0("aicDF$", DFpass[i])))), na.rm = TRUE)

    cat(paste0(models[i], ": ", passed, " (", round((passed/nrow(aicDF))*100, 2),
               "%) curves best or comparable to best\n"))
  }

  pltDF <- data.frame(NewID  = aicDF$NewID, model = models[1],
                      aic    = eval(parse(text = DFaic[1])),
                      delta  = eval(parse(text = paste0("aicDF$",DFdelta[1]))),
                      weight = eval(parse(text = paste0("aicDF$",DFweight[1]))))

  for(i in 2:length(models)){
    pltDF <- rbind.data.frame(pltDF,
                   data.frame(NewID  = aicDF$NewID, model = models[i],
                              aic    = eval(parse(text = DFaic[1])),
                              delta  = eval(parse(text = paste0("aicDF$",DFdelta[i]))),
                              weight = eval(parse(text = paste0("aicDF$",DFweight[i])))))
  }

  plt <- ggplot(data = pltDF, aes(y = weight, x = model))
  plt <- plt + geom_boxplot(outlier.shape=NA)
  plt <- plt + geom_jitter(position=position_jitter(width=.3, height=0), alpha = 0.3, cex = .5)
  plt <- plt + stat_summary(fun.y=mean, geom="point", shape=18, size=5, show.legend = FALSE)
  plt <- plt + theme_classic()
  print(plt)

  fit <- aov(weight ~ model, data = pltDF)

  cat("\n\nNow looking at weighted aic\n\n")
  print(TukeyHSD(fit))

  return(aicDF)
}

###############################################################################
# run the stuff!
###############################################################################

mdls1 <- c("cubic", "flsch", "nhsch", "nlsch", "arrhn")
mdls2 <- c("flsch", "nhsch", "nlsch", "arrhn")

pdf("../Results/compare_aic.pdf")

cat("\nComparing all models---------------------------------------------------------\n")
a <- compare(mdls1)

cat("\nComparing all but cubic model------------------------------------------------\n")
b <- compare(mdls2)

cat("\nSaving plots...\n")

dev.off()

cat("\nDone!\n")

# print time taken in hr:mn:sc.ms (there must be an easier way!)
elapsed <- proc.time() - start_time

hrs = as.character(floor(elapsed[3]/3600))  # hours
hrs = paste0(rep("0", 2 - nchar(hrs)), hrs)

mins = as.character(floor(elapsed[3]/60))  # mins
mins = paste0(rep("0", 2 - nchar(mins)), mins)

secs = as.character(floor(elapsed[3]%%60)) # seconds
secs = paste0(rep("0", 2 - nchar(secs)),secs)

ms = substr(as.character((elapsed[3]%%60)%%1), 3, 5)  # ms

cat(paste0("Time taken: ", hrs, ":", mins, ":", secs, ".", ms, "\n"))

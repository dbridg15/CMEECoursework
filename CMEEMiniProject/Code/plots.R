#!usr/bin/env Rscript

# script: plots.R
# Desc:   plots thermal performance curve for each unique curve and saves to
#         pdf
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# imports
source("plotfuncs.R")
require(gridExtra)
require(grid)

start_time <- proc.time()

###############################################################################
# read in data
###############################################################################

GRDF    <- read.csv("../Results/sorted_data.csv")
flschDF <- read.csv("../Results/full_scholfield_model.csv")
nhschDF <- read.csv("../Results/noh_scholfield_model.csv")
nlschDF <- read.csv("../Results/nol_scholfield_model.csv")
cubicDF <- read.csv("../Results/cubic_model.csv")
arrhnDF <- read.csv("../Results/arrhenius_model.csv")

###############################################################################
# do the plots
###############################################################################


iteration  = 0              # start iteration as 0 for loading bar
iterations = nrow(flschDF)  # iterations for loading bar is number of ids
bar_len = 65                # length of loading bat in terminal

cat("Plotting:\n")

pdf("../Results/plots.pdf", width = 10, height = 12)

for(id in unique(GRDF$NewID)){

  # loading bar ---------------------------------------------------------------
  iteration = iteration + 1  # increment iteration

  percent = iteration/iterations
  hashes  = paste(rep("#", round(percent*bar_len )), collapse = "")  # #'s in loading bar
  spaces  = paste(rep(" ", bar_len - nchar(hashes)), collapse = "")  # empty space in loading bar
  msg     = paste0("\rID ", id, paste(rep(" ", 4 - nchar(id)), collapse = ""))  # message before loading bar
  # print loading bar \r means it overwrites on each iteration
  cat(paste0(msg, " [", hashes, spaces, "] ", round(percent*100), "% "))

  # end of loadign bar --------------------------------------------------------

  plt1 <- KT_plt(id, GRDF)  #1/KT plot with lines for E , Eh and B0
  # plot with data points and model curves overlaid
  plt2 <- models_plt(id, GRDF, flschDF, nhschDF, nlschDF, cubicDF, arrhnDF)

  sctb <- sch_tbl(id, flschDF, nhschDF, nlschDF)  # table with Schoolfield values
  cutb <- cub_tbl(id, cubicDF)                    # table with cubic values
  ahtb <- arh_tbl(id, arrhnDF)                    # table with arrhenius values

  # arrange all the objects in a grid on the page
  grid.arrange(plt1, plt2, sctb, cutb, ahtb,
              nrow = 5,
              as.table = TRUE,
              top=textGrob(paste0("ID: ", id), gp=gpar(fontsize=20,font=3)),
              heights=c(9, 12, 4, 2, 2))
}


dev.off()

cat("\nDone!\n")

cat(paste0("Time taken: ", proc.time() - start_time))

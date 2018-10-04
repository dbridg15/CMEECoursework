#!usr/bin/env Rscript

# script: plots.R
# Desc:   plots thermal performance curve for each unique curve and saves to
#         pdf
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# imports
source("plotfuncs.R")
suppressPackageStartupMessages(require(gridExtra))
suppressPackageStartupMessages(require(grid))

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

# get input arguments
args = commandArgs(trailingOnly = TRUE)

if (length(args) == 1){
    if (args[1] == "All"){
        run_ids = unique(GRDF$NewID)
        cat(paste0("\nPlotting All curves\n"))
    } else{
        run_ids = sample(unique(GRDF$NewID), args[1], replace = FALSE)
        cat(paste0("\nPlotting random ", args[1], " curves\n"))
    }
}else{
    run_ids = sample(unique(GRDF$NewID), 50, replace = FALSE)
    cat(paste0("\nPlotting random 50 curves\n"))
}

iteration  = 0                # start iteration as 0 for loading bar
iterations = length(run_ids)  # iterations for loading bar is number of ids
bar_len = 65                  # length of loading bat in terminal


pdf("../Results/plots.pdf", width = 10, height = 12)

for(id in run_ids){

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

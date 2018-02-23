#!usr/bin/env Rscript

# script:
# Desc:
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# imports
source("plotfuncs.R")
require(gridExtra)
require(grid)

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
#
###############################################################################

pdf("../Sandbox/plots.pdf", width = 10, height = 12)

iteration  = 0
iterations = nrow(flschDF)
bar_len = 65

cat("Plotting:\n")

for(id in unique(GRDF$NewID)){

    iteration = iteration + 1

    percent = iteration/iterations
    hashes  = paste(rep("#", round(percent*bar_len )), collapse = "")
    spaces  = paste(rep(" ", bar_len - nchar(hashes)), collapse = "")
    msg     = paste0("\rID ", id, paste(rep(" ", 4 - nchar(id)), collapse = ""))

    cat(paste0(msg, " [", hashes, spaces, "] ", round(percent*100), "% "))

    plt1 <- KT_plt(id, GRDF)
    plt2 <- models_plt(id, GRDF, flschDF, nhschDF, nlschDF, cubicDF, arrhnDF)

    sctb <- sch_tbl(id, flschDF, nhschDF, nlschDF)
    cutb <- cub_tbl(id, cubicDF)
    ahtb <- arh_tbl(id, arrhnDF)

    grid.arrange(plt1, plt2, sctb, cutb, ahtb,
                nrow = 5,
                as.table = TRUE,
                top=textGrob(paste0("ID: ", id),gp=gpar(fontsize=20,font=3)),
                heights=c(9, 12, 4, 2, 2))
}

cat("\nDone!\n")

dev.off()

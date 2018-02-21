#!usr/bin/env Rscript

# script:
# Desc:
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# imports
source("plotfuncs.R")
require(gridExtra)

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

for(id in unique(GRDF$NewID)){

    print(paste("Plotting id:", id))

    plt1 <- KT_plt(id, GRDF)
    plt2 <- models_plt(id, GRDF, flschDF, nhschDF, nlschDF, cubicDF, arrhnDF)

    sctb <- sch_tbl(id, flschDF, nhschDF, nlschDF)
    cutb <- cub_tbl(id, cubicDF)
    ahtb <- arh_tbl(id, arrhnDF)

    grid.arrange(plt1, plt2, sctb, cutb, ahtb,
                nrow = 5,
                as.table = TRUE,
                heights=c(9, 12, 4, 2, 2))
}

dev.off()

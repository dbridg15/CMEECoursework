#!usr/bin/env Rscript

# script:
# Desc:
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())
graphics.off()

###############################################################################
# required functions
###############################################################################

# sum_vect
sum_vect <- function(x, y){
    mx <- max(length(x), length(y))
    length(x) <- mx
    length(y) <- mx
    x[is.na(x)] <- 0
    y[is.na(y)] <- 0
    x + y
}


# sum_list_vect
sum_list_vect <- function(X){
    tmp <- sum_vect(X[[1]], X[[2]])
    for(i in 3:length(X)){
        tmp <- sum_vect(tmp, X[[i]])
    }
    return(tmp)
}


# octaves
octaves <- function(abundances){
   tabulate(floor(log2(abundances))+1)
}


###############################################################################
# reading in the data and summing vector
###############################################################################

spc_abd_500 <- list()
spc_abd_1000 <- list()
spc_abd_2500 <- list()
spc_abd_5000 <- list()

for(i in 1:100){
    load(paste("../Results/dmb2417_cluster_run_", i, ".rda", sep = ""))
    if(size == 500){
        spc_abd_500 <- c(spc_abd_500,
                         list(sum_list_vect(spc_abd)/length(spc_abd)))
    }
    if(size == 1000){
        spc_abd_1000 <- c(spc_abd_1000,
                         list(sum_list_vect(spc_abd)/length(spc_abd)))
    }
    if(size == 2500){
        spc_abd_2500 <- c(spc_abd_2500,
                         list(sum_list_vect(spc_abd)/length(spc_abd)))
    }
    if(size == 5000){
        spc_abd_5000 <- c(spc_abd_5000,
                         list(sum_list_vect(spc_abd)/length(spc_abd)))
    }
}

spc_abd_500 <- sum_list_vect(spc_abd_500)/length(spc_abd_500)
spc_abd_1000 <- sum_list_vect(spc_abd_1000)/length(spc_abd_1000)
spc_abd_2500 <- sum_list_vect(spc_abd_2500)/length(spc_abd_2500)
spc_abd_5000 <- sum_list_vect(spc_abd_5000)/length(spc_abd_5000)


###############################################################################
# plot!!
###############################################################################

par(mfcol=c(2, 2), oma=c(0,0,2,0))  # initiate 2x2 plot oma is margin for title
barplot(spc_abd_500, xlab = "Species Abundance", ylab = "Average Count",
        main = "J = 500")
barplot(spc_abd_1000, xlab = "Species Abundance", ylab = "Average Count",
        main = "J = 1000")
barplot(spc_abd_2500, xlab = "Species Abundance", ylab = "Average Count",
        main = "J = 2500")
barplot(spc_abd_5000, xlab = "Species Abundance", ylab = "Average Count",
        main = "J = 5000")
title(paste("Speciation Rate:", speciation_rate), outer=TRUE)

#!usr/bin/env Rscript

# script: dmb2417_cluster_read.R
# Desc: reads in and plots data produced from dmb2417_HPC.R
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())
graphics.off()

###############################################################################
# required functions
###############################################################################

# sum_vect - returns the sum of two vectors (without repeating)
sum_vect <- function(x, y){
    mx <- max(length(x), length(y))
    length(x) <- mx
    length(y) <- mx
    x[is.na(x)] <- 0
    y[is.na(y)] <- 0
    return(x + y)
}


# sum_list_vect - returns the sum of a list of vectors
sum_list_vect <- function(X){
    tmp <- sum_vect(X[[1]], X[[2]])
    for(i in 3:length(X)){
        tmp <- sum_vect(tmp, X[[i]])
    }
    return(tmp)
}


###############################################################################
# cluster_read
###############################################################################

cluster_read <- function(filepath = "../Results/dmb2417_cluster_run_",
                        filecount = 100){

    # initialise empty vectors
    spc_abd_500 <- c(0)
    spc_abd_1000 <- c(0)
    spc_abd_2500 <- c(0)
    spc_abd_5000 <- c(0)

    count_500 <- 0
    count_1000 <- 0
    count_2500 <- 0
    count_5000 <- 0

    # for files 1-100, load in the data, append a vector of average octs to the
    # appropriate list
    for(i in 1:filecount){
        load(paste(filepath, i, ".rda", sep = ""))
        if(size == 500){
            spc_abd_500 <- sum_vect(spc_abd_500, sum_list_vect(spc_abd))
            count_500 <- count_500 + length(spc_abd)
        }
        if(size == 1000){
            spc_abd_1000 <- sum_vect(spc_abd_1000, sum_list_vect(spc_abd))
            count_1000 <- count_1000 + length(spc_abd)
        }
        if(size == 2500){
            spc_abd_2500 <- sum_vect(spc_abd_2500, sum_list_vect(spc_abd))
            count_2500 <- count_2500 + length(spc_abd)
        }
        if(size == 5000){
            spc_abd_5000 <- sum_vect(spc_abd_5000, sum_list_vect(spc_abd))
            count_5000 <- count_5000 + length(spc_abd)
        }
    }

    # take the mean of these lists of vectors (effectivley producing a mean of
    # means
    spc_abd_500 <- spc_abd_500/count_500
    spc_abd_1000 <- spc_abd_1000/count_1000
    spc_abd_2500 <- spc_abd_2500/count_2500
    spc_abd_5000 <- spc_abd_5000/count_5000

    par(mfcol=c(2, 2), oma=c(0,0,2,0))  # initiate 2x2 plot oma is margin for title
    barplot(spc_abd_500, xlab = "Species Abundance Octaves",
            ylab = "Average Count", main = "J = 500")
    barplot(spc_abd_1000, xlab = "Species Abundance Octaves",
            ylab = "Average Count", main = "J = 1000")
    barplot(spc_abd_2500, xlab = "Species Abundance Octaves",
            ylab = "Average Count", main = "J = 2500")
    barplot(spc_abd_5000, xlab = "Species Abundance Octaves",
            ylab = "Average Count", main = "J = 5000")
    title(paste("Speciation Rate:", speciation_rate), outer=TRUE)

}

cluster_read()

###############################################################################
# challenge C
###############################################################################

challenge_c <- function(filepath = "../Results/dmb2417_cluster_run_",
                        filecount = 100){

    # initilise empty lists
    spc_rch_500 <- c(0)
    spc_rch_1000 <- c(0)
    spc_rch_2500 <- c(0)
    spc_rch_5000  <- c(0)

    for(i in 1:filecount){
        load(paste(filepath, i, ".rda", sep = ""))
        if(size == 500){
            spc_rch_500 <- sum_vect(spc_rch_500, unlist(spc_rch))
        }
        if(size == 1000){
            spc_rch_1000 <- sum_vect(spc_rch_1000, unlist(spc_rch))
        }
        if(size == 2500){
            spc_rch_2500 <- sum_vect(spc_rch_2500, unlist(spc_rch))
        }
        if(size == 5000){
            spc_rch_5000 <- sum_vect(spc_rch_5000, unlist(spc_rch))
        }
    }

    spc_rch_500 <- spc_rch_500/25
    spc_rch_1000 <- spc_rch_1000/25
    spc_rch_2500 <- spc_rch_2500/25
    spc_rch_5000  <- spc_rch_5000/25

    par(mfcol=c(2, 2), oma=c(0,0,2,0))  # initiate 2x2 plot oma is margin for title
    plot(spc_rch_500, xlab = "Generation", ylab = "Average Species Richness",
            main = "J = 500", cex = 0.2)
    plot(spc_rch_1000, xlab = "Generation", ylab = "Average Species Richness",
            main = "J = 1000", cex = 0.2)
    plot(spc_rch_2500, xlab = "Generation", ylab = "Average Species Richness",
            main = "J = 2500", cex = 0.2)
    plot(spc_rch_5000, xlab = "Generation", ylab = "Average Species Richness",
            main = "J = 5000", cex = 0.2)
    title("Species Richness Over Generations", outer=TRUE)

}

challenge_c()

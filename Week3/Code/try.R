#!usr/bin/env Rscript

# script: try.R
# Desc: catching errors with try
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# required packages

###############################################################################
# try.R
###############################################################################

# simulation sampling a population with try

x <- rnorm(50)  # Generate the population

doit <- function(x){
    x <- sample(x, replace = T)
    if(length(unique(x)) > 30){  # only take the mean if sample is bug enough
        print(paste("Mean of this sample was:", as.character(mean(x))))
    }
    else{
        stop("couldnt calculate mean: too few unique points!")
    }
}

# using try with vecotorization
result <- lapply(1:100, function(i) try(doit(x), F))

# ir using a for loop with try
result <- vector("list", 100)  # initialize the vector
for(i in 1:100){
    result[[i]] <- try(doit(x), F)
}

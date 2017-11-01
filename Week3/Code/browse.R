#!usr/bin/env Rscript

# script: browse.R
# Desc: script demonstrating simple debugging in R
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# required packages

###############################################################################
# 8.5.2 debugging in R
###############################################################################

Exponential <- function(N0 = 1, r = 1, generations = 10){
    # runs silmulation of exponential growth
    # returns vector of length generationso

    N <- rep(NA, generations)

    N[1] <- N0

    for(t in 2:generations){
        N[t] <- N[t-1] * exp(r)
           browser()
    }
    return(N)
}

plot(Exponential(), type = "l", main = "Exponential Growth!")

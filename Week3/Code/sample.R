#!usr/bin/env Rscript

# script: sample.R
# Desc: generating random numbers in r
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# required packages

###############################################################################
# 8.4  generating Random numbers in R
###############################################################################

x <- c(1.4, 1.5, 1.7, 1.8, 1.9)

rnorm(10, m = 0, sd = 1)  # normal random numbers with mean 0 sd 1
dnorm(x, m = 0, sd = 1)  # density function
qnorm(x, m = 0, sd = 1)  # cumulative density function
runif(20, min = 0, max = 2)  # random numbers from uniform 1-2
rpois(20, lambda = 10)  # random numbers from poisson

# seeding random numbers

set.seed(1234567)
rnorm(1)
rnorm(10)

set.seed(Sys.time())

###############################################################################
# sample.R
###############################################################################

x <- rnorm(50)  # Generate the population

doit <- function(x){
    x <- sample(x, replace = T)
    if(length(unique(x)) > 30){
        print(paste("Mean of this sample was:", as.character(mean(x))))
    }
}

# run 100 interations with vectorization
result <- lapply(1:100, function(i) doit(x))

# using a for loop...

result <- vector("list", 100)  # initialize the vector
for(i in 1:100){
    result[[i]] <- doit(x)
}

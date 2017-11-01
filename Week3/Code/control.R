#!usr/bin/env Rscript

# script: control.R
# Desc: control statements in R
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# required packages

###############################################################################
# 7.15 Control statements in R
###############################################################################

# if statement
a <- T
if( a == T){
  print("a is TRUE")
} else {
    print("a is FALSE")
}

# on a single line
z <- runif(1)  # random number
if(z < 0.25){
  print("Less than a quarter!")
}

# for loop using a sequence
for(i in 1:100){
  j <- i * i
  print(paste(i, "squared is", j))
}

# for loop over vector of strings
for(species in c('Heliodoxa rubinoides',
                 'Boissonneaua jardini',
                 'Sula nebouxii')){
  print(paste('The species is', species))
}

# for loop using a vector
v1 <- c("a", "bc", "def")
for(i in v1){
  print(i)
}

# while loop
i <- 0
while(i < 100){
  print(i ^ 2)
  i <- i + 1
}

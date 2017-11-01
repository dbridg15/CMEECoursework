#!usr/bin/env Rscript

# script: Vectorize2.R
# Desc: improved performace using vecorization with stochastic ricker model
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# required packages

###############################################################################
# Ricker model -- with no stochasticity!
###############################################################################

Ricker <- function(N0 = 1, r = 1, k = 10, generations = 50){
    # runs a simulation of the Ricker model
    # returns a vector of legnth generations

    N <- rep(NA, generations)  # created a vector of NA

    N[1] <- N0
    for(t in 2:generations){
        N[t] <- N[t -1] * exp(r*(1.0-(N[t-1]/k)))
    }
    return(N)
}

# plot(Ricker(2,2,100,50), type = "l")
# plot(Ricker())

###############################################################################
# Runs the stochastic (with gaussian fluctuations) Ricker Eqn
###############################################################################

rm(list=ls())

stochrick<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100)
{
  #initialize
  N<-matrix(NA,numyears,length(p0))
  N[1,]<-p0

  for (pop in 1:length(p0)) #loop through the populations
  {
    for (yr in 2:numyears) #for each pop, loop through the years
    {
      N[yr,pop]<-N[yr-1,pop]*exp(r*(1-N[yr-1,pop]/K)+rnorm(1,0,sigma))
    }
  }
  return(N)
}

print("Non-Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrick()))

###############################################################################
# improved function with vectorization
###############################################################################

rm(list=ls())

stochrickvect <- function(p0=runif(1000, .5, 1.5), r = 1.2, k = 1,
                          sigma = 0.2, numyears = 100){
    #initialize
    N<-matrix(NA,numyears,length(p0))
    N[1,]<-p0

    # this actually makes it slower!!!
    # rando <- matrix(rnorm((numyears -1)*1000, 0, sigma), numyears-1, 1000)

    for (yr in 2:numyears){ #for each pop, loop through the years
        N[yr, ] <- N[yr - 1, ] * exp(r * (1 - N[yr-1, ]/k) +
                                     rnorm(1000, 0, sigma))  #rando[yr-1,])
    }
    return(N)
}

print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect()))

plot(stochrickvect()[,1], type = 'l')

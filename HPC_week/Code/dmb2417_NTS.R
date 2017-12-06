#!usr/bin/env Rscript

# script: dmb2417_NTS.R
# Desc: functions leading up to a neutral theory simulation
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())
graphics.off()

###############################################################################
# Neutral Theory Simulations
###############################################################################


# 1
# species_richness - returns the species richness of a given community
species_richness <- function(community){
    return(length(unique(community)))
}


# 2
# initialise_max - returns a community of given size with maximum possible sr
initialise_max <- function(size){
    return(seq(size))
}


# 3
# initialise_min - returns a community of given size with minimum possible sr
initialise_min <- function(size){
    return(rep(1, size))
}


# 4
# choose_two - returns 2 random positions from a sequence
choose_two <- function(x){
    v <- seq(x)
    return(sample(v, 2, replace = FALSE))
}


# 5
# neutral_step - returns a community which has undergone a neutral step
neutral_step <- function(community){
    v <- choose_two(length(community))
    community[v[1]] <- community[v[2]]
    return(community)
}


# 6
# neutral_generation - returns community after a generation of neutral steps
neutral_generation <- function(community){
    gen <- ceiling(length(community)/2)
    while(gen > 0){
        community <- neutral_step(community)
        gen <- gen-1
    }
    return(community)
}


# 7
# neutral_time_series - returns a vector of species richnesses given a starting
# community and duration (no. generations) for neutral theory simulation to run
neutral_time_series <- function(initial,duration){
    sr <- species_richness(initial)
    while(duration > 0){
        initial <- neutral_generation(initial)
        sr <- c(sr, species_richness(initial))
        duration <- duration -1
    }
    return(sr)
}


# 8
# question_8 - plots a time series of the neutral model staring at maximum
# species richness
question_8 <- function(size = 100, runs = 200){
    plot(neutral_time_series(initial = initialise_max(size), duration = runs),
         xlab = 'Generation', ylab = 'Species Richness', type = 'l')
}

# 9
# neutral_step_speciation - returns a community which has undergone a neutral
# step with v possibility of speciation
neutral_step_speciation <- function(community, v){
    if(runif(1) > v){
        neutral_step(community)
    } else {
        pos <- sample(length(community), 1)
        community[pos] <- max(community) + 1
        return(community)
    }
}


# 10
# neutral_generation_speciation - returns a community after a generation of
# neutral steps with speciation
neutral_generation_speciation <- function(community, v){
    gen <- ceiling(length(community)/2)
    while(gen > 0){
        community <- neutral_step_speciation(community = community, v = v)
        gen <- gen-1
    }
    return(community)
}


# 11
# neutral_time_series_speciation - returns a vector of species richnesses given
# a starting community and duration (no. generations) for neutral theory
# with speciation simulation to run
neutral_time_series_speciation <- function(community, v, duration){
    sr <- species_richness(community)
    while(duration > 0){
        community <- neutral_generation_speciation(community, v)
        sr <- c(sr, species_richness(community))
        duration <- duration -1
    }
    return(sr)
}


# 12
# plots neutral_time_series_speciation with communities starting at minimum and
# maximum species richnesses
question_12 <- function(size = 100, v = 0.1, runs = 200){
    plot(neutral_time_series_speciation(initialise_max(size), v=v,
                                        duration = runs),
         type = 'l', col = 'red',
         xlab = "Generations", ylab = "Species Richness")
    lines(neutral_time_series_speciation(initialise_min(size), v=v,
                                         duration = runs),
          col = 'blue')
    legend(runs-50, size-5, legend=c("Initial Maximum", "Initial Minimum"),
       col=c("red", "blue"), lty=1, cex=0.8)
}


# 13
# species_abundance - returns a vector of species abundance, small to large
species_abundance <- function(community){
    return(as.numeric(sort(table(community), decreasing =TRUE)))
}


# 14
# octaves - returns species abundences grouped into bins of 2^n
octaves <- function(abundances){
    return(tabulate(floor(log2(abundances))+1))
}


# 15
# sum_vect - returns the sum of two vectors (without repeating)
sum_vect <- function(x, y){
    mx <- max(length(x), length(y))
    length(x) <- mx
    length(y) <- mx
    x[is.na(x)] <- 0
    y[is.na(y)] <- 0
    return(x + y)
}


# 16
# question_16() - makes barplot of average counts of species in each species
# abundance octaves
question_16 <- function(size = 100, v = 0.1){
    community <- initialise_max(size)
    a <- list()
    for(i in 1:200){
        community <- neutral_generation_speciation(community = community,
                                                   v = v)
        }
    a <-  c(a, list(octaves(species_abundance(community))))
    for(i in 1:2000){
        community <- neutral_generation_speciation(community = community,
                                                   v = v)
        if(i %% 20 == 0){
            a <- c(a, list(octaves(species_abundance(community))))
        }
    }
    b <- sum_vect(a[[1]], a[[2]])
    for(i in 3:length(a)){
        b <- sum_vect(b, a[[i]])
    }
    b <- b/length(a)
    barplot(b, names.arg = c("1", "2-3", "4-7", "8-15", "16-31", "32-63"),
            xlab = "Species Abundance", ylab = "Average Count")
}

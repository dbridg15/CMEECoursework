#!usr/bin/env Rscript

# script:
# Desc:
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())
graphics.off()

###############################################################################
#
###############################################################################

# 1
species_richness <- function(community){
    length(unique(community))
}

# 2
initialise_max <- function(size){
    seq(size)
}

# 3
initialise_min <- function(size){
    rep(1, size)
}

# species_richness(initialise_min(10))
# species_richness(initialise_max(10))

# 4
choose_two <- function(x){
    v <- seq(x)
    sample(v, 2, replace = FALSE)
}

# 5
neutral_step <- function(community){
    v <- choose_two(length(community))
    community[v[1]] <- community[v[2]]
    community
}

# 6
neutral_generation <- function(community){
    gen <- ceiling(length(community)/2)
    while(gen > 0){
#       print(community)
        community <- neutral_step(community)
        gen <- gen-1
    }
    community
}

# 7
neutral_time_series <- function(initial,duration){
    sr <- species_richness(initial)
    while(duration > 0){
        initial <- neutral_generation(initial)
        sr <- c(sr, species_richness(initial))
        duration <- duration -1
    }
    sr
}

# 8
question_8 <- function(size = 100, runs = 200){
    plot(neutral_time_series(initial = initialise_max(size), duration = runs),
         xlab = 'Generation', ylab = 'Species Richness', type = 'l')
}

# 9
neutral_step_speciation <- function(community, v){
    if(runif(1) > v){
        neutral_step(community)
    } else {
        pos <- sample(length(community), 1)
        community[pos] <- max(community) + 1
        community
    }
}

# 10
neutral_generation_speciation <- function(community, v){
    gen <- ceiling(length(community)/2)
    while(gen > 0){
#       print(community)
        community <- neutral_step_speciation(community = community, v = v)
        gen <- gen-1
    }
    community
}


# 11
neutral_time_series_speciation <- function(community, v, duration){
    sr <- species_richness(community)
    while(duration > 0){
        community <- neutral_generation_speciation(community, v)
        sr <- c(sr, species_richness(community))
        duration <- duration -1
    }
    sr
}

# 12
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
species_abundance <- function(community){
    as.numeric(sort(table(community), decreasing =TRUE))
}


# 14
octaves <- function(abundances){
   tabulate(floor(log2(abundances))+1)
}

# 15
sum_vect <- function(x, y){
    mx <- max(length(x), length(y))
    length(x) <- mx
    length(y) <- mx
    x[is.na(x)] <- 0
    y[is.na(y)] <- 0
    x + y
}

# 16
question_16 <- function(size = 100, v = 0.1){
    community <- initialise_max(size)
    a <- list()
    community <- neutral_time_series_speciation(community = community,
                                                v =v, duration =200)
    a <- c(a, octaves(species_abundance(community)))
    for(i in range(1, 2000)){
        community <- neutral_generation_speciation(community = community,
                                                   v = v)
        if(i %% 20 == 0){
            a <- c(a, octaves(species_abundance(community)))
        }
    }
a
}


question_16()

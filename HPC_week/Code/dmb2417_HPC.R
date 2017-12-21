#!usr/bin/env Rscript

# script: dmb2417_HPC.R
# Desc: runs a neutral theory similuation with speciation - run on HPC
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())
graphics.off()

###############################################################################
# required functions
###############################################################################

# initialise_min - returns a community of given size with minimum possible sr
initialise_min <- function(size){
    # repeat 1 size number of times
    return(rep(1, size))
}


# species_richness - returns the species richness of a given community
species_richness <- function(community){
    # counts unique values
    return(length(unique(community)))
}

# species_abundance - returns a vector of species abundance, small to large
species_abundance <- function(community){
    # counts occurences of each value (table) and returns large to small (sort)
    return(as.numeric(sort(table(community), decreasing =TRUE)))
}


# choose_two - returns 2 random positions from a sequence
choose_two <- function(x){
    # initialise a sequence of length(x)
    v <- seq(x)
    # sample two from this new vector with no replacement
    return(sample(v, 2, replace = FALSE))
}


# neutral_step - returns a community which has undergone a neutral step
neutral_step <- function(community){
    # return two indexs of community
    v <- choose_two(length(community))
    # replace the first index with the value in the second
    community[v[1]] <- community[v[2]]
    return(community)
}


# neutral_step_speciation - returns a community which has undergone a neutral
# step with v possibility of speciation
neutral_step_speciation <- function(community, v){
    if(runif(1) > v){
        # no speciation then do neutral_step
        neutral_step(community)
    } else {
        # speciation then replace a random index of community with a new unique
        # value
        pos <- sample(length(community), 1)
        community[pos] <- max(community) + 1
        return(community)
    }
}


# neutral_generation_speciation - returns a community after a generation of
# neutral steps with speciation
neutral_generation_speciation <- function(community, v){
    # a generation is half the length of community (ceiling to ensure integer)
    gen <- ceiling(length(community)/2)
    while(gen > 0){
        # repeat for length of generation
        community <- neutral_step_speciation(community = community, v = v)
        gen <- gen-1
    }
    return(community)
}


# octaves - returns species abundences grouped into bins of 2^n
octaves <- function(abundances){
    return(tabulate(floor(log2(abundances))+1))
}


###############################################################################
# cluster_run
###############################################################################

cluster_run <- function(speciation_rate, size, wall_time, interval_rich,
                        interval_oct, burn_in_generations, output_file_name){
    # initial community is length size with minimal diversity
    community <- initialise_min(size)
    i <- 0  # use to count iterations
    spc_rch  <- list()
    spc_abd <- list()
    # start time
    strt <- proc.time()[3]
    elapsed <- proc.time()[3] - strt
    # while there is still time!
    while(elapsed/60 < wall_time){
        community <- neutral_generation_speciation(community = community,
                                                   v = speciation_rate)
        i <- i+1
        # if still in burn in period
        if(i <= burn_in_generations){
            if(i %% interval_rich == 0){
                # record species richness (every interval_rich iterations)
                spc_rch <- c(spc_rch, list(species_richness(community)))
            }
        # otherwise
        } else{
            if(i %% interval_oct == 0){
                # record abundance in octaves (every interval_oct generations
                spc_abd <- c(spc_abd,
                             list(octaves(species_abundance(community))))
            }
        }
        # recalculate elapsed time
        elapsed <- proc.time()[3] - strt
    }
    # once times nearly up save variables to .rda file
    save(spc_abd, spc_rch, community, elapsed, speciation_rate, size,
         wall_time, interval_rich, interval_oct, burn_in_generations,
         file = output_file_name)
}

# cluster_run(0.1,100,5,1,10,200,"test.rda")
# rm(burn_in_generations,community,elapsed,interval_oct,interval_rich,size,
#    speciation_rate,wall_time,spc_abd,spc_rch)


###############################################################################
# running the code
###############################################################################

# iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))  # uncomment on HPC
iter <- 1  # for testing comment when run on HPC
set.seed(iter)

# size (J) is dependant on simulation number
if((iter+3) %% 4 == 0){
    J = 500
}else if((iter+2) %% 4 == 0){
    J = 1000
}else if((iter+1) %% 4 == 0){
    J = 2500
}else if(iter %% 4 == 0){
    J = 5000
}

v = 0.004346  # my personal speciation rate!
interval_rich = 1
interval_oct = round(J/10)  # depends on J
burn_in_generations = J*8  #depends on J
output_file_name = paste("dmb2417_cluster_run_", iter, ".rda", sep = "")

# uncomment below to run!
# cluster_run(speciation_rate = v, size = J, wall_time = (11.5*60),
#             interval_rich = interval_rich, interval_oct = interval_oct,
#             burn_in_generations = burn_in_generations,
#             output_file_name = output_file_name)

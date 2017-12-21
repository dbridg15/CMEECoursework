#!usr/bin/env Rscript

# script: dmb2417.R
# Desc: code from HPC programming excercises
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())
graphics.off()

###############################################################################
# Neutral Theory Simulations
###############################################################################


############################# 1 species_richness ##############################

# returns the species richness of a given community
species_richness <- function(community){
    # counts unique values
    return(length(unique(community)))
}

# species_richness(c(1, 4, 4, 5, 1, 6, 1))


############################# 2 initialise_max ################################

# initialise_max - returns a community of given size with maximum possible sr
initialise_max <- function(size){
    # returns a sequence (1,2,3,4...) of length size
    return(seq(size))
}

# initialise_max(7)


############################# 3 initialise_min ################################

# initialise_min - returns a community of given size with minimum possible sr
initialise_min <- function(size){
    # repeat 1 size number of times
    return(rep(1, size))
}

# initialise_min(4)


############################## 4 choose_two ###################################

# choose_two - returns 2 random positions from a sequence
choose_two <- function(x){
    # initialise a sequence of length x
    v <- seq(x)
    # sample two from this new vector with no replacement
    return(sample(v, 2, replace = FALSE))
}

# choose_two(4)


############################# 5 neutral_step ##################################

# neutral_step - returns a community which has undergone a neutral step
neutral_step <- function(community){
    # return two indexes from the community
    v <- choose_two(length(community))
    # replace the first index with the value of the second
    community[v[1]] <- community[v[2]]
    return(community)
}

# neutral_step(c(10, 5, 13))


############################ 6 neutral_generation #############################

# neutral_generation - returns community after a generation of neutral steps
neutral_generation <- function(community){
    # generation is half the size of the community
    gen <- ceiling(length(community)/2)
    while(gen > 0){
        # for length of generation do neutral_step
        community <- neutral_step(community)
        gen <- gen-1
    }
    return(community)
}

# neutral_generation(initialise_max(10))


######################### 7 neutral_time_series ###############################

# neutral_time_series - returns a vector of species richnesses given a starting
# community and duration (no. generations) for neutral theory simulation to run
neutral_time_series <- function(initial,duration){
    sr <- species_richness(initial)  # starting species richness
    while(duration > 0){  # do durtation times
        initial <- neutral_generation(initial)
        # append sr with new species richness
        sr <- c(sr, species_richness(initial))
        duration <- duration -1
    }
    return(sr)
}

# neutral_time_series(initial = initialise_max(7), duration = 20)


############################ 8 question_8 #####################################

# question_8 - plots a time series of the neutral model staring at maximum
# species richness
question_8 <- function(size = 100, runs = 200){
    plot(neutral_time_series(initial = initialise_max(size), duration = runs),
         xlab = 'Generation', ylab = 'Species Richness', type = 'l')
}

# pdf("../Results/question_8.pdf", width = 10, height = 6)
# question_8()
# dev.off()


###################### 9 neutral_step_speciation ##############################

# neutral_step_speciation - returns a community which has undergone a neutral
# step with v possibility of speciation
neutral_step_speciation <- function(community, v){
    if(runif(1) > v){
        # no speciation then do neutral step
        neutral_step(community)
    } else {
        # speciation then replace a random index of community with a new unique
        # value
        pos <- sample(length(community), 1)
        community[pos] <- max(community) + 1
        return(community)
    }
}

# neutral_step_speciation(c(10, 5, 13), v = 0.2)


################### 10 neutral_generation_speciation ##########################

# neutral_generation_speciation - returns a community after a generation of
# neutral steps with speciation
neutral_generation_speciation <- function(community, v){
    # a generation is half the length of communtiy (ceiling to ensure integer)
    gen <- ceiling(length(community)/2)
    while(gen > 0){
        # repeat for length of generation
        community <- neutral_step_speciation(community = community, v = v)
        gen <- gen-1
    }
    return(community)
}

# neutral_generation_speciation(initialise_min(10), v = 0.2)


##################### 11 neutral_time_series_speciation #######################

# neutral_time_series_speciation - returns a vector of species richnesses given
# a starting community and duration (no. generations) for neutral theory
# with speciation simulation to run
neutral_time_series_speciation <- function(community, v, duration){
    sr <- species_richness(community)
    while(duration > 0){
        community <- neutral_generation_speciation(community, v)
        # append sr with new sr
        sr <- c(sr, species_richness(community))
        duration <- duration -1
    }
    return(sr)
}

# neutral_time_series_speciation(initialise_min(10), v = 0.2, duration = 20)


############################ 12 question_12 ###################################

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

# pdf("../Results/question_12.pdf", width = 10, height = 6)
# question_12(, v = 0.01)
# dev.off()


########################## 13 species_abundance #3#############################

# species_abundance - returns a vector of species abundance, small to large
species_abundance <- function(community){
    # counts occurences of each value (table) and returns large to small (sort)
    return(as.numeric(sort(table(community), decreasing =TRUE)))
}

# species_abundance(c(1, 5, 3, 6, 5, 6, 1, 1))


########################### 14 octaves ########################################

# octaves - returns species abundences grouped into bins of 2^n
octaves <- function(abundances){
    return(tabulate(floor(log2(abundances))+1))
}

# octaves(c(100, 64, 63, 5, 4, 3, 2, 2, 1, 1, 1, 1))


############################ 15 sum_vect ######################################

# sum_vect - returns the sum of two vectors (without repeating)
sum_vect <- function(x, y){
    mx <- max(length(x), length(y))  # whats the maximum length
    # set the length of both vectors to the max length (fills with NAs)
    length(x) <- mx
    length(y) <- mx
    # replace NAs with 0s
    x[is.na(x)] <- 0
    y[is.na(y)] <- 0
    # now vectors are same length they can be summed as normal
    return(x + y)
}

# sum_vect(c(1, 3), c(1, 0, 5, 2))


########################## sum_list_vect ######################################

# sum_list_vect - returns the sum of a list of vectors - makes life easier!
sum_list_vect <- function(X){
    # initialise a tmp vector which is the sum of the first two in the list
    tmp <- sum_vect(X[[1]], X[[2]])
    # iterate through 3rd in the list to the end adding these to tmp
    for(i in 3:length(X)){
        tmp <- sum_vect(tmp, X[[i]])
    }
    return(tmp)
}

# sum_list_vect(list(c(1,2,3,4),c(5,6,7),c(8,9)))


########################### 16 question_16 ####################################

# question_16() - makes barplot of average counts of species in each species
# abundance octaves
question_16 <- function(size = 100, v = 0.1){
    community <- initialise_max(size)  # start at max richness
    a <- list()  # initialise empty vector
    for(i in 1:200){  # burn-in period
        community <- neutral_generation_speciation(community = community,
                                                   v = v)
        }
    # once burn-in is over record  species abundances in octaves every 20
    # iterations
    a <-  c(a, list(octaves(species_abundance(community))))
    for(i in 1:2000){
        community <- neutral_generation_speciation(community = community,
                                                   v = v)
        if(i %% 20 == 0){
            a <- c(a, list(octaves(species_abundance(community))))
        }
    }
    # get the mean of the octaves
    b <- sum_list_vect(a)
    b <- b/length(a)
    # make barplot
    barplot(b, names.arg = c("1", "2-3", "4-7", "8-15", "16-31", "32-63"),
            xlab = "Species Abundance Octaves", ylab = "Average Count")
    return(b)
}

# pdf("../Results/question_16.pdf", width = 10, height = 5)
# question_16()
# dev.off()


########################## Challenge A ########################################

# challenge_A - makes two plots of average species richness with 97.2%
# confidence limits for initial max and min richness over first 1000 generation
challenge_A <- function(size = 100, v = 0.1, runs = 100){

    # simulaiton - returns vector of species richness at each generation
    simulation <- function(community, v){
        a <- species_richness(community)
        for(i in 1:999){
            community <- neutral_generation_speciation(community = community,
                                                        v = v)
            a <- c(a, species_richness(community))
        }
        return(a)
    }

    # initialise empty vector to put in sr for each run of the simulation
    srmx <- c()
    # do the simulation runs times and add sr as new row to srmx
    for(i in 1:runs){
        srmx <- rbind(srmx, simulation(initialise_max(size), v))
    }

    # initialise vectors for lower bound, upper bound and mean
    srmx_lb <- c(species_richness(initialise_max(size)))
    srmx_ub <- c(species_richness(initialise_max(size)))
    srmx_avg <- c(species_richness(initialise_max(size)))

    # for each column in srmx calculate lb, ub and mean and append to vectors
    for(i in 2:ncol(srmx)){
        # lower bound of confidence interval (from t-test)
        srmx_lb <- c(srmx_lb, as.numeric(t.test(srmx[,i],
                                                conf.level=.972)$conf.int[1]))
        # upper bound on confidence interval (from t-test)
        srmx_ub <- c(srmx_ub, as.numeric(t.test(srmx[,i],
                                                conf.level=.972)$conf.int[2]))
        # mean
        srmx_avg <- c(srmx_avg, mean(srmx[,i]))
    }

    # same as above but for initialise_min()
    srmn <- c()
    for(i in 1:runs){
        srmn <- rbind(srmn, simulation(initialise_min(size), v))
    }

    # initialise vectors with first values
    srmn_lb <- c(species_richness(initialise_min(size)))
    srmn_ub <- c(species_richness(initialise_min(size)))
    srmn_avg <- c(species_richness(initialise_min(size)))
    for(i in 2:ncol(srmn)){
        # lower bound of confidence interval
        srmn_lb <- c(srmn_lb, as.numeric(t.test(srmn[,i],
                                                conf.level=.972)$conf.int[1]))
        # upper bound on confidence interval
        srmn_ub <- c(srmn_ub, as.numeric(t.test(srmn[,i],
                                                conf.level=.972)$conf.int[2]))
        srmn_avg <- c(srmn_avg, mean(srmn[,i]))
    }


    par(mfrow=c(2, 1), mar = c(5, 5, 1, 1))  # initialise plot with 2 rows
    # empty plot
    plot(0, type = 'n', xlab = "Generations", ylab = "Average species richness",
        xlim = c(0,1000), ylim = c(10,35), bty = 'l',
        main = "Initial Species RIchness: 100")
    # add confidence limits as polygon
    polygon(c(1:1000, rev(1:1000)), c(srmx_ub, rev(srmx_lb)),
            col = rgb(1,0,0, alpha = 0.5), border = NA)
    # add mean
    lines(srmx_avg, col = "red", lwd = 1)
    abline(v=50)
    plot(0, type = 'n', xlab = "Generations", ylab = "Average species richness",
        xlim = c(0,1000), ylim = c(10,35), bty = 'l',
        main = "Initial Species Richness: 1")
    polygon(c(1:1000, rev(1:1000)), c(srmn_ub, rev(srmn_lb)),
            col = rgb(0,0,1, alpha = 0.5), border = NA)
    lines(srmn_avg, col = "blue", lwd = 1)
    abline(v=50)
    return(rbind(srmx_ub, srmx_avg, srmx_lb, srmn_ub, srmn_avg, srmn_lb))
}


# it takes a little while to run!
# pdf("../Results/challenge_A.pdf", width = 10, height = 8)
# challenge_A()
# dev.off()


############################ Challenge B ######################################

# challenge_B - plots average species richness by generation with 97.2%
# confidence intervals for communities of given starting richnesses
# size = community size, v = speciation rate, runs = repeats for each community
# size, rows and cols = grid for plot, rch = vector of starting richnesses to
# test, gen = generations to run it for
challenge_B <- function(size = 100, v = 0.1, runs = 25, rows = 4, cols = 3,
                        rch = c(1,10,20,30,40,50,60,70,80,90,100), gen = 500){

    # simulaiton - returns vector of species richness at each generation
    simulation <- function(community, gens, v){
        a <- species_richness(community)
        for(i in 1:(gens-1)){
            community <- neutral_generation_speciation(community = community,
                                                        v = v)
            a <- c(a, species_richness(community))
        }
        return(a)
    }

    # initial_com - returns a community of given size and species richness with
    # as close as possible equal species abundances
    initial_com <- function(size, sr){
        # repeat a sequence of length species richness, ceiling/(size/sr) times
        # and then truncate to length size
        return(rep(seq(sr), ceiling(size/sr))[1:size])
    }

    # initialise plot with 4 rows and 3 columns
    par(mfrow=c(rows, cols), mar = c(5, 5, 1, 1))

    # do for communities with these starting richness in rch
    for(j in rch){

        # initialise empty vector to put in sr for each run of the simulation
        sr <- c()
        # community has species richness j and size size
        com <- initial_com(size, j)
        for(i in 1:runs){
            # do simulaiton and add vector of species richness as new row to sr
            sr <- rbind(sr, simulation(com, gen, v))
        }

        # initialise vectors with first values
        sr_lb <- c(species_richness(com))
        sr_ub <- c(species_richness(com))
        sr_avg <- c(species_richness(com))
        for(i in 2:ncol(sr)){
            # lower bound of confidence interval (from t.test)
            sr_lb <- c(sr_lb, as.numeric(t.test(sr[,i],
                                                conf.level=.972)$conf.int[1]))
            # upper bound on confidence interval (from t.test)
            sr_ub <- c(sr_ub, as.numeric(t.test(sr[,i],
                                                conf.level=.972)$conf.int[2]))
            # mean
            sr_avg <- c(sr_avg, mean(sr[,i]))
        }

        # plot!!
        plot(0, type = 'n', xlab = "Generations",
             ylab = "Average species richness", xlim = c(0,gen),
             ylim = c(10,35), bty = 'l', main = paste("Initial Richness:", j))
        # confidence limits as ploygon
        polygon(c(1:gen, rev(1:gen)), c(sr_ub, rev(sr_lb)),
            col = rgb(0,1,0, alpha = 0.3), border = NA)
        # mean as line
        lines(sr_avg, col = "green", lwd = 1)
    }
}

# this also takes time!
# pdf("../Results/challenge_B.pdf", width = 10, height = 14)
# challenge_B()
# dev.off()


###############################################################################
# cluster_read
###############################################################################

# cluster_read - reads in the .rda files produced from the simulations run on
# HPC, finds and plots as barplots the mean counts of species abundance in
# octaves
cluster_read <- function(filepath = "../Data/dmb2417_cluster_run_",
                        filecount = 100){

    # initialise empty vectors
    spc_abd_500 <- c(0)
    spc_abd_1000 <- c(0)
    spc_abd_2500 <- c(0)
    spc_abd_5000 <- c(0)

    # and start counters at 0
    count_500 <- 0
    count_1000 <- 0
    count_2500 <- 0
    count_5000 <- 0

    # for files 1-100, load in the data, append a vector of average octs to the
    # appropriate list
    for(i in 1:filecount){
        load(paste(filepath, i, ".rda", sep = ""))  # load in data
        if(size == 500){
            # sum all spc_abd and add this to current sum
            spc_abd_500 <- sum_vect(spc_abd_500, sum_list_vect(spc_abd))
            count_500 <- count_500 + length(spc_abd)  # add no. runs to counter
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

    # take the mean of these lists of vectors (the overall mean of spc_abd for
    # each community size
    spc_abd_500 <- spc_abd_500/count_500
    spc_abd_1000 <- spc_abd_1000/count_1000
    spc_abd_2500 <- spc_abd_2500/count_2500
    spc_abd_5000 <- spc_abd_5000/count_5000

    par(mfcol=c(2, 2), oma=c(0,0,2,0))  # initiate 2x2 plot
    # add barplot for each community size
    barplot(spc_abd_500, xlab = "Species Abundance Octaves",
            ylab = "Average Count", main = "Community Size = 500")
    barplot(spc_abd_1000, xlab = "Species Abundance Octaves",
            ylab = "Average Count", main = "Community Size = 1000")
    barplot(spc_abd_2500, xlab = "Species Abundance Octaves",
            ylab = "Average Count", main = "Community Size = 2500")
    barplot(spc_abd_5000, xlab = "Species Abundance Octaves",
            ylab = "Average Count", main = "Community Size = 5000")
    # title(paste("Speciation Rate:", speciation_rate), outer=TRUE)
    return(list(spc_abd_500, spc_abd_1000, spc_abd_2500, spc_abd_5000))
}

# pdf("../Results/cluster_read.pdf", width = 10, height = 7.5)
# cluster_read()
# dev.off()

########################## challenge C ########################################

# challenge_c <- plots a graph of mean species richness against simulation
# generation during the burn-in period for the 4 different community sizes
challenge_C <- function(filepath = "../Data/dmb2417_cluster_run_",
                        filecount = 100){

    # initilise empty lists
    spc_rch_500 <- c(0)
    spc_rch_1000 <- c(0)
    spc_rch_2500 <- c(0)
    spc_rch_5000  <- c(0)

    for(i in 1:filecount){  # for all files
        load(paste(filepath, i, ".rda", sep = ""))  # load in data
        if(size == 500){
            # sum spc_rch and add to current sum
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

    # calculate means - there were 25 runs for each community size
    spc_rch_500 <- spc_rch_500/25
    spc_rch_1000 <- spc_rch_1000/25
    spc_rch_2500 <- spc_rch_2500/25
    spc_rch_5000  <- spc_rch_5000/25

    # plot!
    par(mfcol=c(2, 2), oma=c(0,0,2,0))  # initiate 2x2 plot oma is margin
    plot(spc_rch_500, xlab = "Generation", ylab = "Average Species Richness",
            main = "Community Size = 500", cex = 0.05)
    plot(spc_rch_1000, xlab = "Generation", ylab = "Average Species Richness",
            main = "Community Size = 1000", cex = 0.05)
    plot(spc_rch_2500, xlab = "Generation", ylab = "Average Species Richness",
            main = "Community Size = 2500", cex = 0.05)
    plot(spc_rch_5000, xlab = "Generation", ylab = "Average Species Richness",
            main = "Community Size = 5000", cex = 0.05)
    # title("Species Richness Over Generations", outer=TRUE)

}

# pdf("../Results/challenge_C.pdf", width = 10, height = 7.5)
# challenge_C()
# dev.off()

########################### challenge D #######################################


# challenge D - simulation using coalescence
challenge_D <- function(J = 100, v = 0.1){
    a <- list()
    for(i in 1:2000){
        lineages <- rep(1, J)  # initialise vector length J full of 1s
        abundances <- c()  # initialise empty vector abundances
        N <- J  # N = J to start with
        O <- v*((J-1)/(1-v))  # calculate theta

        while(N > 1){  # while lineages has more than 1 number
            # equivalent of choose_two
            tmp <- sample(1:length(lineages), 2, replace = FALSE)
            j <- tmp[1]
            i <- tmp[2]

            if(runif(1) < (O/(O+N-1))){
                # if randnum is < then append lineages[j] onto abundances
                abundances <- c(abundances, lineages[j])
            } else{
                # otherwise replace lineages [i] with lineages[j]
                lineages[i]  <- lineages[i] + lineages[j]
            }

            lineages  <- lineages[-j]  # remove lineages[j] from vector
            N <- N-1  #
        }

        # append the final value in lineages to abundances
        abundances <- c(abundances, lineages)
        # as octaves
        a <- c(a, list(octaves(abundances)))
    }
    # mean
    b <- sum_list_vect(a)/length(a)
    barplot(b, names.arg = c("1", "2-3", "4-7", "8-15", "16-31", "32-63"),
            xlab = "Species Abundance Octaves", ylab = "Average Count")
    return(b)
}

# challenge_D()


###############################################################################
# fractals in nature
###############################################################################


############################ 19 the chaos game! ###############################

# chaos_game - draws a sierpinski triangle between the three points a, b, c
chaos_game <- function(np = 1000){
    # points to draw between
    a <- c(0, 0)
    b <- c(3, 4)
    c <- c(4, 1)
    #starting point
    X <- c(0, 0)
    # plot starting point
    plot(X[1], X[2], cex = 0.1, xlim = c(0, 4), ylim = c(0, 4),
         xaxt = 'n', yaxt = 'n', ann = FALSE, bty = 'n')
    # put points in list which can be referenced
    z <- c(list(a), list(b), list(c))
    for(i in 1:np){
        # target point is radomly chosen from the 3
        target_point <- z[[sample(c(1,2,3), 1)]]
        # calculate new x and y points, replace X with these and plot
        new_x <- target_point[1] - ((target_point[1] - X[1])/2)
        new_y <- target_point[2] - ((target_point[2] - X[2])/2)
        X <- c(new_x, new_y)
        points(X[1], X[2], cex = 0.1)
    }
}

# chaos_game()


############################## challenge E ####################################

# challenge_E - draws an equerlateral sierpinski triangle - colours and bolds
# earlier points and starts from outside the triangle
challenge_E <- function(np = 1000){
    # starting points equadistant
    a <- c(0, 0)
    b <- c(4, 0)
    c <- c(2, sqrt(12))
    X <- c(0, 4)  # starting outside the triangle!!
    par(mar=c(0,0,0,0))
    plot(X[1], X[2], cex = 1, col = "red", xlim = c(0, 4), ylim = c(0, 4),
         pch = 19, xaxt = 'n', yaxt = 'n', ann = FALSE, bty = 'n')
    z <- c(list(a), list(b), list(c))
    for(i in 1:np){
        if(i < 20){  # for the first 20 plot larger red points!
            pcol <- "red"
            pcex = 1
        } else{
            pcol <- "black"
            pcex = 0.1
        }
        target_point <- z[[sample(c(1,2,3), 1)]]
        new_x <- target_point[1] - ((target_point[1] - X[1])/2)
        new_y <- target_point[2] - ((target_point[2] - X[2])/2)
        X <- c(new_x, new_y)
        points(X[1], X[2], cex = pcex, col = pcol, pch = 19)
    }
}

# challenge_E(5000)


################################ 20 turtle ####################################

# turtle - draws a line starting from a given position, in a given direction
# and of a given length
turtle <- function(start_pos = c(0,0), direction = pi/4, v_len = 1){
    # calculate end x and y coordincates based on star, direction and length
    end_x = start_pos[1] + cos(direction)*v_len
    end_y = start_pos[2] + sin(direction)*v_len
    # plot line between the two points
    segments(start_pos[1], start_pos[2], end_x, end_y)
    # return the new x and y
    return(c(end_x, end_y))
}

# plot.new()
# plot.window(xlim = c(-1,1), ylim = c(-1,1))
# turtle()


################################ 21 elbow #####################################

# elbow - calls turtle twice with the second pi/4 radians to the rihht and
# 0.95 time the length
elbow <- function(start_pos = c(0,0), direction = pi/4, v_len = 1){
    # does turtle and replaces start_pos with the end point of turtle
    start_pos <- turtle(start_pos, direction, v_len)
    direction2  <- direction - (pi/4)  # pi/2 to the right
    v_len1<- v_len*0.95  # slightly shorter new length
    # do turtle with these new starting parameters
    turtle(start_pos, direction2, v_len1)
}

# plot.new()
# plot.window(xlim = c(0,4), ylim = c(-2,2))
# elbow()


############################## 22 spiral ######################################

# spiral - similar to elbow but calls itself so draws an infinate spiral! and
# causes stack overflow error
spiral <- function(start_pos = c(0,0), direction = pi/4, v_len = 1){
    start_pos <- turtle(start_pos, direction, v_len)
    direction2  <- direction - (pi/4)
    v_len1 <- v_len*0.95
    # calls itself!
    spiral(start_pos, direction2, v_len1)
}

# plot.new()
# plot.window(xlim = c(0,4), ylim = c(-2,2))
# spiral()


############################## 23 spiral_2 ####################################

# spiral2 - like spiral but stops once length goes below threshold valuee (e)
spiral_2 <- function(start_pos = c(0,0), direction = pi/4, v_len = 1,
                     e = 0.01){  # new variable e (min length)
    if(v_len > e){  # only do if length hasnt got too small!
        start_pos <- turtle(start_pos, direction, v_len)
        direction2  <- direction - (pi/4)
        v_len1 <- v_len*0.95
        spiral_2(start_pos, direction2, v_len1, e)
    }
}

# plot.new()
# plot.window(xlim = c(0,2.5), ylim = c(-1,1.1))
# spiral_2(c(0,0), direction = pi/3, v_len = 1)


################################ 24 tree ######################################

# tree - similar to spiral but calls itself twice in opposite directions so it
# draws a  nice looking tree
tree <- function(start_pos = c(0,0), direction = pi/2 , v_len = 1, e = 0.01){
    if(v_len > e){
        start_pos <- turtle(start_pos, direction, v_len)
        # directions to the left and right
        direction2  <- direction - (pi/4)
        direction3 <- direction + (pi/4)
        v_len1 <- v_len*0.65
        # calls itself twice once in each of the new directions
        tree(start_pos, direction2, v_len1, e)
        tree(start_pos, direction3, v_len1, e)
    }
}

# plot.new()
# plot.window(xlim = c(-1.5,1.5), ylim = c(0,2.5))
# tree()

############################### 25 fern #######################################

# fern - draws a fern
fern <- function(start_pos = c(0,0), direction = pi/2 , v_len = 1, e = 0.01){
    if(v_len > e){
        start_pos <- turtle(start_pos, direction, v_len)
        # this time one direction remains the same, the other goes left
        direction3  <- direction + (pi/4)
        direction2 <- direction
        v_len1 <- v_len*0.87
        v_len2 <- v_len*0.38
        fern(start_pos, direction2, v_len1, e)
        fern(start_pos, direction3, v_len2, e)
    }
}

# plot.new()
# plot.window(xlim = c(-3,3), ylim = c(0,8))
# fern()


############################## 26 fern_2 ######################################

# fern_2 - draws a nicer looking fern!
# new variable dir which alternates direction left and right
fern_2 <- function(start_pos = c(0,0), direction = pi/2 , v_len = 1,
                   e = 0.01, dir = -1){
    if(v_len > e){
        start_pos <- turtle(start_pos, direction, v_len)
        dir <- -dir  # alternate dir
        direction3 <- direction + (dir*(pi/4))  # left/right depending on dir
        direction2 <- direction  # continue on
        v_len1 <- v_len*0.87
        v_len2 <- v_len*0.38
        fern_2(start_pos, direction2, v_len1, dir, e=e)
        fern_2(start_pos, direction3, v_len2, -dir, e=e)
    }
}


# plot.new()
# plot.window(xlim = c(-2,2), ylim = c(0,7.5))
# fern_2()
#
# a <- proc.time()
# plot.new()
# plot.window(xlim = c(-2,2), ylim = c(0,7.5))
# fern_2(e = 0.1)
# proc.time() - a  # elapsed = 0.169s
#
# a <- proc.time()
# plot.new()
# plot.window(xlim = c(-2,2), ylim = c(0,7.5))
# fern_2(e = 0.005)
# proc.time() - a  # elapsed = 23.599s


######################### challenge F #########################################

# challenge_F1 - draws a christmas tree with a poor attempt at a koch snowflake
# as a star
challenge_F1 <- function(){

    # new turtle function which also takes in colour and width of line
    turtle2 <- function(start_pos = c(0,0), direction = pi/4, v_len = 1,
                        colour = "black", width = 0.1){
        end_x = start_pos[1] + cos(direction)*v_len
        end_y = start_pos[2] + sin(direction)*v_len
        segments(start_pos[1], start_pos[2], end_x, end_y, col = colour,
                 lwd = width)
        return(c(end_x, end_y))
    }

    # christmas_tree - draws a christmas tree!
    christmas_tree  <- function(start_pos = c(0,0), direction= pi/2, v_len = 1,
                                e = 0.01, dir = -1, colour = "", width = 5){

        # different shades of green to choose from!
        tree_cols <- c("yellowgreen", "springgreen", "springgreen1",
                        "springgreen2", "springgreen3", "springgreen4",
                        "palegreen2", "palegreen3", "palegreen4", "olivedrab",
                        "olivedrab3", "olivedrab4", "green2", "green3",
                        "green4", "forestgreen", "darkgreen", "darkolivegreen",
                        "darkolivegreen3", "darkolivegreen4")

        if(v_len > e){
            # sample colour from the list!
            start_pos <- turtle2(start_pos, direction, v_len,
                                colour = sample(tree_cols), width)
            dir <- -dir
            direction3 <- direction + (dir*(pi/2))
            direction2 <- direction
            # chaned length a but so the trees more dense!
            v_len1 <- v_len*0.9
            v_len2 <- v_len*0.41
            christmas_tree(start_pos, direction2, v_len1, dir, e=e,
                        colour = sample(tree_cols), width)
            christmas_tree(start_pos, direction3, v_len2, -dir, e=e,
                        colour = sample(tree_cols), width)
        }
    }

    # function draws a triangle given a point (middle of bottom side), size of
    # the sides and angle of the bottom side to the horizontal
    triangle <- function(initial, size, angle, colour){
        # calculate the vertices of the triangle
        v1 <- c(initial[1] + cos(angle)*(0.5*size),
                initial[2] - sin(angle)*(0.5*size))
        v2 <- c(initial[1] - cos(angle)*(0.5*size),
                initial[2] + sin(angle)*(0.5*size))
        v3 <- c(initial[1] + cos((pi/2)-angle)*size*sqrt(0.75),
                initial[2] + sin((pi/2)-angle)*size*sqrt(0.75))
        # plot the polygon
        polygon(rbind(v1,v2,v3), col = colour,
                border = colour)
        # return the coordinates of the vertices
        return(rbind(v1, v2, v3))
    }

    # returns the midpoint of two points!
    midpt <- function(pt1 = c(0,0), pt2 = c(1,1)){
        newx <- pt1[1] - ((pt1[1] - pt2[1])/2)
        newy <- pt1[2] - ((pt1[2] - pt2[2])/2)
        return(c(newx, newy))
    }

    # koch - attempt to draw a koch snowflake
    koch <- function(initial = c(0,10.5), size = 1.3, angle = pi){
        # shades of yellow to sample from
        star_cols <- c("gold", "gold1", "gold2", "goldenrod", "goldenrod2",
                    "goldenrod3", "yellow", "yellow1", "yellow2")
        # draw a triangle and return coordinates of vertices
        a <- triangle(initial, size, angle, colour = sample(star_cols))
        if(size > 0.01){  # if size is still big enough!
            # calculate the midpoint and angle of each side of the just drawn
            # triangle
            initiala <- midpt(a[1,], a[2,])
            anglea <- -((pi) - angle)
            initialb <- midpt(a[2,], a[3,])
            angleb <- -((pi/3)-angle)
            initialc <- midpt(a[3,], a[1,])
            anglec <- angle + (pi/3)
            nsize <- size/3  # new size is 1/3 of old size
            # now call koch again to draw a triangle in the middle of each of
            # the sides of the previously drawn triangle
            koch(initial = initiala, size = nsize, angle = anglea)
            koch(initial = initialb, size = nsize, angle = angleb)
            koch(initial = initialc, size = nsize, angle = anglec)
        }
    }
christmas_tree()
koch()
}

# pdf("../Results/challenge_F1.pdf", width = 7.5, height = 10)
# plot.new()
# plot.window(xlim = c(-4,4), ylim = c(0,10.5))
# challenge_F1()
# dev.off()

# challenge_F2 - the koch snowflake on its own! (or a poor atempt at it)
challenge_F1.1 <- function(){
  # function draws a triangle given a point (middle of bottom side), size of
  # the sides and angle of the bottom side to the horizontal
  triangle <- function(initial, size, angle, colour){
        # calculate the vertices of the triangle
        v1 <- c(initial[1] + cos(angle)*(0.5*size),
                initial[2] - sin(angle)*(0.5*size))
        v2 <- c(initial[1] - cos(angle)*(0.5*size),
                initial[2] + sin(angle)*(0.5*size))
        v3 <- c(initial[1] + cos((pi/2)-angle)*size*sqrt(0.75),
                initial[2] + sin((pi/2)-angle)*size*sqrt(0.75))
        # plot the polygon
        polygon(rbind(v1,v2,v3), col = colour,
                border = colour)
        # return the coordinates of the vertices
        return(rbind(v1, v2, v3))
    }

    # returns the midpoint of two points!
    midpt <- function(pt1 = c(0,0), pt2 = c(1,1)){
        newx <- pt1[1] - ((pt1[1] - pt2[1])/2)
        newy <- pt1[2] - ((pt1[2] - pt2[2])/2)
        return(c(newx, newy))
    }

    # koch - attempt to draw a koch snowflake
    koch <- function(initial = c(0,10), size = 0.7, angle = pi){
        # shades of yellow to sample from
        star_cols <- c("gold", "gold1", "gold2", "goldenrod", "goldenrod2",
                    "goldenrod3", "yellow", "yellow1", "yellow2")
        # draw a triangle and return coordinates of vertices
        a <- triangle(initial, size, angle, colour = sample(star_cols))
        if(size > 0.01){
            # calculate the midpoint and angle of each side of the just drawn
            # triangle
            initiala <- midpt(a[1,], a[2,])
            anglea <- -((pi) - angle)
            initialb <- midpt(a[2,], a[3,])
            angleb <- -((pi/3)-angle)
            initialc <- midpt(a[3,], a[1,])
            anglec <- angle + (pi/3)
            nsize <- size/3  # new size is 1/3 the previous
            # now call koch again to draw a triangle in the middle of each of
            # the sides of the previously drawn triangle
            koch(initial = initiala, size = nsize, angle = anglea)
            koch(initial = initialb, size = nsize, angle = angleb)
            koch(initial = initialc, size = nsize, angle = anglec)
        }
    }
	koch(initial = c(0,0), size = 1, angle = 0)  # call koch
}

# plot.new()
# plot.window(xlim = c(-1,1), ylim = c(-1,1))
# challenge_F1.1()


######################### challenge G #########################################

challenge_G <- function(){
f=function(x=0,y=0,d=pi/2,l=9,r=-1){
if(l>.1){
z=x+cos(d)*l
q=y+sin(d)*l
segments(x,y,z,q)
p=d+(-r*.8)
n=l*.9
b=l*.4
f(z,q,d,n,-r)
f(z,q,p,b,r)}}
f()
}

# plot.new()
# plot.window(xlim = c(-23,23), ylim = c(0,85))
# challenge_G()

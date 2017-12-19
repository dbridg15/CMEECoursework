#!usr/bin/env Rscript

# script: dmb2417_NTS.R
# Desc: code from HPC programming excercises
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())
graphics.off()

###############################################################################
# Neutral Theory Simulations
###############################################################################


############################# 1 species_richnes ###############################

# returns the species richness of a given community
species_richness <- function(community){
    return(length(unique(community)))
}

# species_richness(c(1, 4, 4, 5, 1, 6, 1))


############################# 2 initialise_max ################################

# initialise_max - returns a community of given size with maximum possible sr
initialise_max <- function(size){
    return(seq(size))
}

# initialise_max(7)


############################# 3 initialise_min ################################

# initialise_min - returns a community of given size with minimum possible sr
initialise_min <- function(size){
    return(rep(1, size))
}

# initialise_min(4)


############################## 4 choose_two ###################################

# choose_two - returns 2 random positions from a sequence
choose_two <- function(x){
    v <- seq(x)
    return(sample(v, 2, replace = FALSE))
}

# choose_two(4)


############################# 5 neutral_step ##################################

# neutral_step - returns a community which has undergone a neutral step
neutral_step <- function(community){
    v <- choose_two(length(community))
    community[v[1]] <- community[v[2]]
    return(community)
}

# neutral_step(c(10, 5, 13))


############################ 6 neutral_generation #############################

# neutral_generation - returns community after a generation of neutral steps
neutral_generation <- function(community){
    gen <- ceiling(length(community)/2)
    while(gen > 0){
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
    sr <- species_richness(initial)
    while(duration > 0){
        initial <- neutral_generation(initial)
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

# question_8()


###################### 9 neutral_step_speciation ##############################

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

# neutral_step_speciation(c(10, 5, 13), v = 0.2)


################### 10 neutral_generation_speciation ##########################

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

# neutral_generation_speciation(initialise_min(10), v = 0.2)


##################### 11 neutral_time_series_speciation #######################

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

# question_12()


########################## 13 species_abundance #3#############################

# species_abundance - returns a vector of species abundance, small to large
species_abundance <- function(community){
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
    mx <- max(length(x), length(y))
    length(x) <- mx
    length(y) <- mx
    x[is.na(x)] <- 0
    y[is.na(y)] <- 0
    return(x + y)
}

# sum_vect(c(1, 3), c(1, 0, 5, 2))


########################## sum_list_vect ######################################

# sum_list_vect - returns the sum of a list of vectors - makes life easier!
sum_list_vect <- function(X){
    tmp <- sum_vect(X[[1]], X[[2]])
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
    b <- sum_list_vect(a)
    b <- b/length(a)
    barplot(b, names.arg = c("1", "2-3", "4-7", "8-15", "16-31", "32-63"),
            xlab = "Species Abundance Octaves", ylab = "Average Count")
}

# question_16()


###############################################################################
# cluster_read
###############################################################################

cluster_read <- function(filepath = "../Data/dmb2417_cluster_run_",
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

    par(mfcol=c(2, 2), oma=c(0,0,2,0))  # initiate 2x2 plot
    barplot(spc_abd_500, xlab = "Species Abundance Octaves",
            ylab = "Average Count", main = "Community Size = 500")
    barplot(spc_abd_1000, xlab = "Species Abundance Octaves",
            ylab = "Average Count", main = "Community Size = 1000")
    barplot(spc_abd_2500, xlab = "Species Abundance Octaves",
            ylab = "Average Count", main = "Community Size = 2500")
    barplot(spc_abd_5000, xlab = "Species Abundance Octaves",
            ylab = "Average Count", main = "Community Size = 5000")
    # title(paste("Speciation Rate:", speciation_rate), outer=TRUE)

}

# cluster_read()


###############################################################################
# challenge C
###############################################################################

challenge_c <- function(filepath = "../Data/dmb2417_cluster_run_",
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

# challenge_c()


###############################################################################
# fractals in nature
###############################################################################


############################ 19 the chaos game! ###############################

# chaos_game - draws a sierpinski triangle between the three points a, b, c
chaos_game <- function(np = 1000){
    a <- c(0, 0)
    b <- c(3, 4)
    c <- c(4, 1)
    X <- c(0, 0)
    plot(X[1], X[2], cex = 0.1, xlim = c(0, 4), ylim = c(0, 4),
         xaxt = 'n', yaxt = 'n', ann = FALSE, bty = 'n')
    z <- c(list(a), list(b), list(c))
    for(i in 1:np){
        target_point <- z[[sample(c(1,2,3), 1)]]
        new_x <- target_point[1] - ((target_point[1] - X[1])/2)
        new_y <- target_point[2] - ((target_point[2] - X[2])/2)
        X <- c(new_x, new_y)
        points(X[1], X[2], cex = 0.1)
    }
}

# chaos_game()


############################## challenge E ####################################

# challenge_e - draws an equerlateral sierpinski triangle - colours and bolds
# earlier points and starts from outside the triangle
challenge_e <- function(np = 1000){
    a <- c(0, 0)
    b <- c(4, 0)
    c <- c(2, sqrt(12))
    X <- c(0, 4)
    plot(X[1], X[2], cex = 0.3, col = "red", xlim = c(0, 4), ylim = c(0, 4),
         pch = 19, xaxt = 'n', yaxt = 'n', ann = FALSE, bty = 'n')
    z <- c(list(a), list(b), list(c))
    for(i in 1:np){
        if(i < 50){
            pcol <- "red"
            pcex = 0.3
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

# challenge_e(5000)


################################ 20 turtle ####################################

# turtle - draws a line starting from a given position, in a given direction
# and of a given length
turtle <- function(start_pos = c(0,0), direction = pi/4, v_len = 1){
    end_x = start_pos[1] + cos(direction)*v_len
    end_y = start_pos[2] + sin(direction)*v_len
    segments(start_pos[1], start_pos[2], end_x, end_y)
    return(c(end_x, end_y))
}

# plot.new()
# plot.window(xlim = c(-1,1), ylim = c(-1,1))
# turtle()


################################ 21 elbow #####################################

# elbow - calls turtle twice with the second pi/4 radians to the rihht and
# 0.95 time the length
elbow <- function(start_pos = c(0,0), direction = pi/4, v_len = 1){
    start_pos <- turtle(start_pos, direction, v_len)
    direction2  <- direction - (pi/4)
    v_len1<- v_len*0.95
    turtle(start_pos, direction2, v_len1)
}

# plot.new()
# plot.window(xlim = c(0,4), ylim = c(-2,2))
# elbow()


############################## 22 spiral ######################################

# spiral - similar to elbow but calls itself so draws an infinate spiral
spiral <- function(start_pos = c(0,0), direction = pi/4, v_len = 1){
    start_pos <- turtle(start_pos, direction, v_len)
    direction2  <- direction - (pi/4)
    v_len1 <- v_len*0.95
    spiral(start_pos, direction2, v_len1)
}

# plot.new()
# plot.window(xlim = c(0,4), ylim = c(-2,2))
# spiral()


############################## 23 spiral_2 ####################################

# spiral2 - like spiral but stops once length goes below threshold valuee (e)
spiral_2 <- function(start_pos = c(0,0), direction = pi/4, v_len = 1,
                     e = 0.01){
    if(v_len > e){
        start_pos <- turtle(start_pos, direction, v_len)
        direction2  <- direction - (pi/4)
        v_len1 <- v_len*0.95
        spiral_2(start_pos, direction2, v_len1, e)
    }
}

# plot.new()
# plot.window(xlim = c(0,2.5), ylim = c(-1.5,1))
# spiral_2()


################################ 24 tree ######################################

# tree - similar to spiral but calls itself twice in opposite directions so it
# draws a  nice looking tree
tree <- function(start_pos = c(0,0), direction = pi/2 , v_len = 1, e = 0.01){
    if(v_len > e){
        start_pos <- turtle(start_pos, direction, v_len)
        direction2  <- direction - (pi/4)
        direction3 <- direction + (pi/4)
        v_len1 <- v_len*0.65
        tree(start_pos, direction2, v_len1, e)
        tree(start_pos, direction3, v_len1, e)
    }
}

# plot.new()
# plot.window(xlim = c(-3,3), ylim = c(0,3))
# tree()


############################### 25 fern #######################################

# fern - draws a fern
fern <- function(start_pos = c(0,0), direction = pi/2 , v_len = 1, e = 0.01){
    if(v_len > e){
        start_pos <- turtle(start_pos, direction, v_len)
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
fern_2 <- function(start_pos = c(0,0), direction = pi/2 , v_len = 1,
                   e = 0.01, dir = -1){
    if(v_len > e){
        start_pos <- turtle(start_pos, direction, v_len)
        dir <- -dir
        direction3 <- direction + (dir*(pi/4))
        direction2 <- direction
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

    turtle2 <- function(start_pos = c(0,0), direction = pi/4, v_len = 1,
                        colour = "black", width = 0.1){
        end_x = start_pos[1] + cos(direction)*v_len
        end_y = start_pos[2] + sin(direction)*v_len
        segments(start_pos[1], start_pos[2], end_x, end_y, col = colour)
        return(c(end_x, end_y))
    }

    christmas_tree  <- function(start_pos = c(0,0), direction= pi/2, v_len = 1,
                                e = 0.01, dir = -1, colour = "", width = 0.7){

        tree_cols <- c("yellowgreen", "springgreen", "springgreen1",
                        "springgreen2", "springgreen3", "springgreen4",
                        "palegreen2", "palegreen3", "palegreen4", "olivedrab",
                        "olivedrab3", "olivedrab4", "green2", "green3",
                        "green4", "forestgreen", "darkgreen", "darkolivegreen",
                        "darkolivegreen3", "darkolivegreen4")

        if(v_len > e){
            start_pos <- turtle2(start_pos, direction, v_len,
                                colour = sample(tree_cols), width)
            dir <- -dir
            direction3 <- direction + (dir*(pi/2))
            direction2 <- direction
            v_len1 <- v_len*0.9
            v_len2 <- v_len*0.41
            christmas_tree(start_pos, direction2, v_len1, dir, e=e,
                        colour = sample(tree_cols), width)
            christmas_tree(start_pos, direction3, v_len2, -dir, e=e,
                        colour = sample(tree_cols), width)
        }
    }

    triangle <- function(initial, size, angle, colour){
        v1 <- c(initial[1] + cos(angle)*(0.5*size),
                initial[2] - sin(angle)*(0.5*size))
        v2 <- c(initial[1] - cos(angle)*(0.5*size),
                initial[2] + sin(angle)*(0.5*size))
        v3 <- c(initial[1] + cos((pi/2)-angle)*size*sqrt(0.75),
                initial[2] + sin((pi/2)-angle)*size*sqrt(0.75))
        polygon(rbind(v1,v2,v3), col = colour,
                border = colour)
        return(rbind(v1, v2, v3))
    }

    midpt <- function(pt1 = c(0,0), pt2 = c(1,1)){
        newx <- pt1[1] - ((pt1[1] - pt2[1])/2)
        newy <- pt1[2] - ((pt1[2] - pt2[2])/2)
        return(c(newx, newy))
    }

    koch <- function(initial = c(0,10), size = 0.7, angle = pi){
        star_cols <- c("gold", "gold1", "gold2", "goldenrod", "goldenrod2",
                    "goldenrod3", "yellow", "yellow1", "yellow2")
        a <- triangle(initial, size, angle, colour = sample(star_cols))
        if(size > 0.01){
            initiala <- midpt(a[1,], a[2,])
            anglea <- -((pi) - angle)
            initialb <- midpt(a[2,], a[3,])
            angleb <- -((pi/3)-angle)
            initialc <- midpt(a[3,], a[1,])
            anglec <- angle + (pi/3)
            nsize <- size/3
            koch(initial = initiala, size = nsize, angle = anglea)
            koch(initial = initialb, size = nsize, angle = angleb)
            koch(initial = initialc, size = nsize, angle = anglec)
        }
    }
christmas_tree()
koch()
}

# plot.new()
# plot.window(xlim = c(-4,4), ylim = c(0,10))
# challenge_F1()


# challenge_F2 - the koch snowflake on its own! (or a poor atempt at it)
challenge_F2 <- function(){
  triangle <- function(initial, size, angle, colour){
        v1 <- c(initial[1] + cos(angle)*(0.5*size),
                initial[2] - sin(angle)*(0.5*size))
        v2 <- c(initial[1] - cos(angle)*(0.5*size),
                initial[2] + sin(angle)*(0.5*size))
        v3 <- c(initial[1] + cos((pi/2)-angle)*size*sqrt(0.75),
                initial[2] + sin((pi/2)-angle)*size*sqrt(0.75))
        polygon(rbind(v1,v2,v3), col = colour,
                border = colour)
        return(rbind(v1, v2, v3))
    }

    midpt <- function(pt1 = c(0,0), pt2 = c(1,1)){
        newx <- pt1[1] - ((pt1[1] - pt2[1])/2)
        newy <- pt1[2] - ((pt1[2] - pt2[2])/2)
        return(c(newx, newy))
    }

    koch <- function(initial = c(0,10), size = 0.7, angle = pi){
        star_cols <- c("gold", "gold1", "gold2", "goldenrod", "goldenrod2",
                    "goldenrod3", "yellow", "yellow1", "yellow2")
        a <- triangle(initial, size, angle, colour = sample(star_cols))
        if(size > 0.01){
            initiala <- midpt(a[1,], a[2,])
            anglea <- -((pi) - angle)
            initialb <- midpt(a[2,], a[3,])
            angleb <- -((pi/3)-angle)
            initialc <- midpt(a[3,], a[1,])
            anglec <- angle + (pi/3)
            nsize <- size/3
            koch(initial = initiala, size = nsize, angle = anglea)
            koch(initial = initialb, size = nsize, angle = angleb)
            koch(initial = initialc, size = nsize, angle = anglec)
        }
    }
	koch(initial = c(0,0), size = 1, angle = 0)
}

# plot.new()
# plot.window(xlim = c(-1,1), ylim = c(-1,1))
# challenge_F2()

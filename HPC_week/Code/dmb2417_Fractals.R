#!usr/bin/env Rscript

# script:
# Desc:
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())
graphics.off()

###############################################################################
# fractals in nature
###############################################################################


############################ 19 the chaos game! ###############################


chaos_game <- function(np = 1000){
    a <- c(0, 0)
    b <- c(3, 4)
    c <- c(4, 1)
    X <- c(0, 0)
    plot(X[1], X[2], cex = 0.1, xlim = c(0, 4), ylim = c(0, 4))
    z <- c(list(a), list(b), list(c))
    for(i in 1:np){
        target_point <- z[[sample(c(1,2,3), 1)]]
        new_x <- max(target_point[1], X[1]) - ((max(target_point[1], X[1]) -
                                                min(target_point[1], X[1]))/2)
        new_y <- max(target_point[2], X[2]) - ((max(target_point[2], X[2]) -
                                                min(target_point[2], X[2]))/2)
        X <- c(new_x, new_y)
        points(X[1], X[2], cex = 0.1)
    }
}

# chaos_game()


################################ 20 turtle ####################################


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


spiral_2 <- function(start_pos = c(0,0), direction = pi/4, v_len = 1){
    if(v_len > 0.01){
        start_pos <- turtle(start_pos, direction, v_len)
        direction2  <- direction - (pi/4)
        v_len1 <- v_len*0.95
        spiral_2(start_pos, direction2, v_len1)
    }
}

# plot.new()
# plot.window(xlim = c(0,3), ylim = c(-2,2))
# spiral_2()


################################ 24 tree ######################################


tree <- function(start_pos = c(0,0), direction = pi/2 , v_len = 1){
    if(v_len > 0.01){
        start_pos <- turtle(start_pos, direction, v_len)
        direction2  <- direction - (pi/4)
        direction3 <- direction + (pi/4)
        v_len1 <- v_len*0.65
        tree(start_pos, direction2, v_len1)
        tree(start_pos, direction3, v_len1)
    }
}

# plot.new()
# plot.window(xlim = c(-3,3), ylim = c(0,3))
# tree()


############################### 25 fern #######################################


fern <- function(start_pos = c(0,0), direction = pi/2 , v_len = 1){
    if(v_len > 0.01){
        start_pos <- turtle(start_pos, direction, v_len)
        direction3  <- direction + (pi/4)
        direction2 <- direction
        v_len1 <- v_len*0.87
        v_len2 <- v_len*0.38
        fern(start_pos, direction2, v_len1)
        fern(start_pos, direction3, v_len2)
    }
}

# plot.new()
# plot.window(xlim = c(-3,3), ylim = c(0,8))
# fern()



############################## 26 fern_2 ######################################

fern_2 <- function(start_pos = c(0,0), direction = pi/2 , v_len = 1, dir = -1){
    if(v_len > 0.01){
        start_pos <- turtle(start_pos, direction, v_len)
        direction3  <- direction + (pi/4)
        direction2 <- direction
        v_len1 <- v_len*0.87
        v_len2 <- v_len*0.38
        fern_2(start_pos, direction2, v_len1, dir)
        fern_2(start_pos, direction3, v_len2, -dir)
    }
}

plot.new()
plot.window(xlim = c(-3,3), ylim = c(0,10))
fern_2()

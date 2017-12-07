#!usr/bin/env Rscript

# script:
# Desc:
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())
graphics.off()

###############################################################################
# fractals in nature
###############################################################################

# 19 the chaos game!

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

# 20 turtle

turtle <- function(start_pos = c(0,0), direction = pi/4, v_len = 1){
    end_x = start_pos[1] + cos(direction)*v_len
    end_y = start_pos[2] + sin(direction)*v_len
    segments(start_pos[1], start_pos[2], end_x, end_y)
}

# plot.new()
# plot.window(xlim = c(-1,1), ylim = c(-1,1))
# turtle()

# 21 elbow

elbow <- function(start_pos = c(0,0), direction = pi/4, v_len = 1){


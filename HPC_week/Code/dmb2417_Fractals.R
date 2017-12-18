#!usr/bin/env Rscript

# script:
# Desc:
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())
graphics.off()

###############################################################################
# fractals in nature
###############################################################################

# menger sponge (cube)
# sierpinski carpet

############################ 19 the chaos game! ###############################

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

challenge_e(5000)

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
# plot.window(xlim = c(0,3), ylim = c(-2,2))
# spiral_2()


################################ 24 tree ######################################


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


challenge_F <- function(){

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

plot.new()
plot.window(xlim = c(-4,4), ylim = c(0,10))
challenge_F()


#!usr/bin/env Rscript

# script:
# Desc:
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# imports
require(ggplot2)
require(knitr)
require(dplyr)

###############################################################################
# constants
###############################################################################

k <- 8.6173303e-05
e <- exp(1)

###############################################################################
# basic plots
###############################################################################

# basic plot of Trait Value by Temp
basic_plt <- function(id, dataframe){

    tmp <- subset(dataframe, NewID == id)

    plt <- ggplot(data = tmp, aes(UsedTemp, StandardisedTraitValue))
    plt <- plt + geom_point(color = "red")
    plt <- plt + theme_classic()
    print(plt)
}

# plot of logged trait value by 1/kT
KT_plt <- function(id, dataframe){

    tmp <- subset(dataframe, NewID == id)

    plt <- ggplot(data = tmp, aes(adjTemp, STVlogged))
    plt <- plt + geom_point(color = "blue")
    plt <- plt + theme_classic()

    plt <- plt + geom_abline(slope = tmp$E[1], intercept = tmp$Eint[1],
                             lty = 6, lwd = 1, color = "red")
    plt <- plt + geom_abline(slope = tmp$Eh[1], intercept = tmp$Ehint[1],
                             lty = 6, lwd = 1, color = "green")

    plt <- plt + geom_segment(x = -10000, xend = (1/(283.15*k)),
                              y = tmp$B0[1], yend = tmp$B0[1],
                              lwd = .8, lty = 5, color = "blue")
    plt <- plt + geom_segment(x = (1/(283.15*k)), xend = (1/(283.15*k)),
                              y = -10000, yend = tmp$B0[1],
                              lwd = .8, lty = 5, color = "blue")
    print(plt)
}


###############################################################################
# model x and y from NLLS output
###############################################################################

# return x and y values from full schoolfield model using values from NLLS
full_schfld <- function(id, data, values){

    if (is.na(subset(values, NewID == id)$chisqr)){
        print("Full Schoolfield did not converge")
    } else {
        x <- subset(data, NewID == id)$UsedTemp
        x <- seq(min(x), max(x), length.out = 100)

        B0 <- subset(values, NewID == id)$B0
        E  <- subset(values, NewID == id)$E
        Eh <- subset(values, NewID == id)$Eh
        El <- subset(values, NewID == id)$El
        Th <- subset(values, NewID == id)$Th
        Tl <- subset(values, NewID == id)$Tl

        y <- log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                1+(e**((El/k)*((1/Tl)-(1/x))))+(e**((Eh/k)*((1/Th)-(1/x))))))
        data.frame(x, y)
    }
}


# return x and y values from noh schoolfield model using values from NLLS
noh_schfld <- function(id, data, values){

    if (is.na(subset(values, NewID == id)$chisqr)){
        print("No high Schoolfield did not converge")
    } else {
        x <- subset(data, NewID == id)$UsedTemp
        x <- seq(min(x), max(x), length.out = 100)

        B0 <- subset(values, NewID == id)$B0
        E  <- subset(values, NewID == id)$E
        El <- subset(values, NewID == id)$El
        Tl <- subset(values, NewID == id)$Tl

        y <- log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                                           1+(e**((El/k)*((1/Tl)-(1/x))))))
        data.frame(x, y)
    }
}


# return x and y values from nol schoolfield model using values from NLLS
nol_schfld <- function(id, data, values){

    if (is.na(subset(values, NewID == id)$chisqr)){
        print("no low schoolfield did not converge")
    } else {
        x <- subset(data, NewID == id)$UsedTemp
        x <- seq(min(x), max(x), length.out = 100)

        B0 <- subset(values, NewID == id)$B0
        E  <- subset(values, NewID == id)$E
        Eh <- subset(values, NewID == id)$Eh
        Th <- subset(values, NewID == id)$Th

        y <- log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                                             1+(e**((Eh/k)*((1/Th)-(1/x))))))
        data.frame(x, y)
    }
}

# return x and y values from cubic model using values from NLLS
cubic <- function(id, data, values){

    if (is.na(subset(values, NewID == id)$chisqr)){
        print("Cubic model did not converge")
    } else {
        x <- subset(data, NewID == id)$UsedTemp
        x <- seq(min(x), max(x), length.out = 100)

        a <- subset(values, NewID == id)$a
        b <- subset(values, NewID == id)$b
        c <- subset(values, NewID == id)$c
        d <- subset(values, NewID == id)$d

        y <- a + b*x + c*x^2 + d*x^3

        data.frame(x, y)
    }
}


###############################################################################
# plot fitted models onto the data
###############################################################################

# plot all models
models_plot <- function(id, dataframe, flsVals, nhsVals, nlsVals, cubicvals){

    tmp <- subset(dataframe, NewID == id)

    plt <- ggplot(tmp, aes(UsedTemp, STVlogged))
    plt <- plt + geom_point()
    plt <- plt + theme_classic()

    try(plt <- plt + geom_line(data = full_schfld(id, dataframe, flsVals),
                           aes(x, y), lty = 6, lwd = 1, color = "red"),
        silent = TRUE)
    try(plt <- plt + geom_line(data = noh_schfld(id, dataframe, nhsVals),
                           aes(x, y), lty = 5, lwd = 1, color = "blue"),
        silent = TRUE)
    try(plt <- plt + geom_line(data = nol_schfld(id, dataframe, nlsVals),
                           aes(x, y), lty = 4, lwd = 1, color = "green"),
        silent = TRUE)
    try(plt <- plt + geom_line(data = cubic(id, dataframe, cubicvals),
                           aes(x, y), lty = 4, lwd = 1, color = "yellow"),
        silent = TRUE)

    print(plt)
}

# models_plot(3, GRDF, flschDF, nhschDF, nlschDF, cubicDF)


###############################################################################
# summary tables of NLLS outputs
###############################################################################

# table summaring results of NLLS for schoolfield models
sch_tbl <- function(id, flsch, nhsch, nlsch){
    full <- subset(flsch, NewID == id)
    full$model <- "Full"
    noh  <- subset(nhsch, NewID == id)
    noh$model <- "noh"
    nol  <- subset(nlsch, NewID == id)
    nol$model <- "nol"
    sch  <- bind_rows(full, noh, nol)
    sch  <- sch[c("model", "B0", "E", "Eh", "El", "Th", "Tl", "aic", "bic",
                  "chisqr")]
    rownames(sch) <- NULL
    kable(sch)
}

# table summaring results of NLLS for cubic model
cub_tbl <- function(id, cubm){
    cub <- subset(cubm, NewID == id)
    cub$model <- "cubic"
    cub <- cub[c("model", "a", "b", "c", "d", "aic", "bic", "chisqr")]
    rownames(cub) <- NULL
    kable(cub)
}

# sch_tbl(3, flschDF, nhschDF, nlschDF)
# cub_tbl(3, cubicDF)

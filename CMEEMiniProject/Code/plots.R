#!usr/bin/env Rscript

# script:
# Desc:
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# imports
require(ggplot2)

###############################################################################
# constants
###############################################################################

k <- 8.6173303e-05
e <- exp(1)

###############################################################################
# read in sorted data and results of NLLS
###############################################################################

GRDF    <- read.csv("../Results/Sorted_data.csv")
flschDF <- read.csv("../Results/full_scholfield_model.csv")
nhschDF <- read.csv("../Results/noh_scholfield_model.csv")
nlschDF <- read.csv("../Results/nol_scholfield_model.csv")
cubicDF <- read.csv("../Results/cubic_model.csv")

###############################################################################
#
###############################################################################

id <- 1317

# basic plot
basic_plt <- function(id, dataframe){

    tmp <- subset(dataframe, NewID == id)

    plt <- ggplot(data = tmp, aes(UsedTemp, StandardisedTraitValue))
    plt <- plt + geom_point(color = "red")
    plt <- plt + theme_classic()
    print(plt)
}

# 1/kT plot
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


# return x and y values from full schoolfield model using values from NLLS
full_schfld <- function(id, data, values){

    x <- subset(data, NewID == id)$UsedTemp
    x <- seq(min(x), max(x), length.out = 100)

    B0 <- subset(values, Newid == id)$B0
    E  <- subset(values, Newid == id)$E
    Eh <- subset(values, Newid == id)$Eh
    El <- subset(values, Newid == id)$El
    Th <- subset(values, Newid == id)$Th
    Tl <- subset(values, Newid == id)$Tl

    y <- log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
             1+(e**((El/k)*((1/Tl)-(1/x))))+(e**((Eh/k)*((1/Th)-(1/x))))))
    data.frame(x, y)
}


# return x and y values from noh schoolfield model using values from NLLS
noh_schfld <- function(id, data, values){

    x <- subset(data, NewID == id)$UsedTemp
    x <- seq(min(x), max(x), length.out = 100)

    B0 <- subset(values, Newid == id)$B0
    E  <- subset(values, Newid == id)$E
    El <- subset(values, Newid == id)$El
    Tl <- subset(values, Newid == id)$Tl

    y <- log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                                               1+(e**((El/k)*((1/Tl)-(1/x))))))
    data.frame(x, y)
}


# return x and y values from nol schoolfield model using values from NLLS
nol_schfld <- function(id, data, values){

    x <- subset(data, NewID == id)$UsedTemp
    x <- seq(min(x), max(x), length.out = 100)

    B0 <- subset(values, Newid == id)$B0
    E  <- subset(values, Newid == id)$E
    Eh <- subset(values, Newid == id)$Eh
    Th <- subset(values, Newid == id)$Th

    y <- log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                                               1+(e**((Eh/k)*((1/Th)-(1/x))))))
    data.frame(x, y)
}


# plot all models
models_plot <- function(id, dataframe, flsVals, nhsVals, nlsVals){

    tmp <- subset(dataframe, NewID == id)

    plt <- ggplot(tmp, aes(UsedTemp, STVlogged))
    plt <- plt + geom_point()
    plt <- plt + theme_classic()
    plt <- plt + geom_line(data = full_schfld(id, dataframe, flsVals),
                           aes(x, y), lty = 6, lwd = 1, color = "red")
    plt <- plt + geom_line(data = noh_schfld(id, dataframe, nhsVals),
                           aes(x, y), lty = 5, lwd = 1, color = "blue")
    plt <- plt + geom_line(data = nol_schfld(id, dataframe, nlsVals),
                           aes(x, y), lty = 4, lwd = 1, color = "green")
    print(plt)
}


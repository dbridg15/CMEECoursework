#!usr/bin/env Rscript

# script:
# Desc:
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# imports
require(ggplot2)
require(dplyr)
require(gridExtra)

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

    plt <- ggplot(data = tmp, aes(UsedTempK, StandardisedTraitValue))
    plt <- plt + geom_point()
    plt <- plt + theme_classic()
    return(plt)
}

# plot of logged trait value by 1/kT
KT_plt <- function(id, dataframe){

    tmp <- subset(dataframe, NewID == id)

    plt <- ggplot(data = tmp, aes(adjTemp, STVlogged))
    plt <- plt + geom_point()
    plt <- plt + theme_classic()

    plt <- plt + geom_abline(slope = tmp$E[1], intercept = tmp$Eint[1],
                             lty = 6, color = "red")
    plt <- plt + geom_abline(slope = tmp$Eh[1], intercept = tmp$Ehint[1],
                             lty = 6, color = "green")

    plt <- plt + geom_segment(x = -10000, xend = (1/(283.15*k)),
                              y = tmp$B0[1], yend = tmp$B0[1],
                              lty = 5, color = "blue")
    plt <- plt + geom_segment(x = (1/(283.15*k)), xend = (1/(283.15*k)),
                              y = -10000, yend = tmp$B0[1],
                              lty = 5, color = "blue")
    plt <- plt + xlab("1/kT")
    plt <- plt + ylab("Logged Trait Value")
    return(plt)
}


###############################################################################
# model x and y from NLLS output
###############################################################################

# return x and y values from full schoolfield model using values from NLLS
full_schfld <- function(id, data, values){

    if (is.na(subset(values, NewID == id)$chisqr)){
        # print("Full Schoolfield did not converge")
    } else {
        x <- subset(data, NewID == id)$UsedTempK
        x <- seq(min(x), max(x), length.out = 100)

        B0 <- subset(values, NewID == id)$B0
        E  <- subset(values, NewID == id)$E
        Eh <- subset(values, NewID == id)$Eh
        El <- subset(values, NewID == id)$El
        Th <- subset(values, NewID == id)$Th
        Tl <- subset(values, NewID == id)$Tl

        y <- log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                1+(e**((El/k)*((1/Tl)-(1/x))))+(e**((Eh/k)*((1/Th)-(1/x))))))
        data.frame(x, y, model = "Full Schoolfield")
    }
}


# return x and y values from noh schoolfield model using values from NLLS
noh_schfld <- function(id, data, values){

    if (is.na(subset(values, NewID == id)$chisqr)){
        # print("No high Schoolfield did not converge")
    } else {
        x <- subset(data, NewID == id)$UsedTempK
        x <- seq(min(x), max(x), length.out = 100)

        B0 <- subset(values, NewID == id)$B0
        E  <- subset(values, NewID == id)$E
        El <- subset(values, NewID == id)$El
        Tl <- subset(values, NewID == id)$Tl

        y <- log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                                           1+(e**((El/k)*((1/Tl)-(1/x))))))
        data.frame(x, y, model = "No High Schoolfield")
    }
}


# return x and y values from nol schoolfield model using values from NLLS
nol_schfld <- function(id, data, values){

    if (is.na(subset(values, NewID == id)$chisqr)){
        # print("no low schoolfield did not converge")
    } else {
        x <- subset(data, NewID == id)$UsedTempK
        x <- seq(min(x), max(x), length.out = 100)

        B0 <- subset(values, NewID == id)$B0
        E  <- subset(values, NewID == id)$E
        Eh <- subset(values, NewID == id)$Eh
        Th <- subset(values, NewID == id)$Th

        y <- log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                                             1+(e**((Eh/k)*((1/Th)-(1/x))))))
        data.frame(x, y, model = "No Low Schoolfield")
    }
}

# return x and y values from cubic model using values from NLLS
cubic <- function(id, data, values){

    if (is.na(subset(values, NewID == id)$chisqr)){
        # print("Cubic model did not converge")
    } else {
        x <- subset(data, NewID == id)$UsedTemp
        x <- seq(min(x), max(x), length.out = 100)

        a <- subset(values, NewID == id)$a
        b <- subset(values, NewID == id)$b
        c <- subset(values, NewID == id)$c
        d <- subset(values, NewID == id)$d

        y <- a + b*x + c*x^2 + d*x^3

        x <- x + 273.15
        y <- log(y)

        data.frame(x, y, model = "Cubic")
    }
}

# return x and y values from arrhenius model using values from NLLS
arrhenius <- function(id, data, values){

    if (is.na(subset(values, NewID == id)$chisqr)){
        # print("Cubic model did not converge")
    } else {
        x <- subset(data, NewID == id)$UsedTempK
        x <- seq(min(x), max(x), length.out = 100)

        A0      <- subset(values, NewID == id)$A0
        Ea      <- subset(values, NewID == id)$Ea
        deltaCp <- subset(values, NewID == id)$deltaCp
        deltaH  <- subset(values, NewID == id)$deltaH
        trefs   <- subset(values, NewID == id)$trefs

        y <- log(A0)-((Ea-deltaH*(1-x/trefs)-deltaCp*(x-trefs-x*log(x/trefs)))/(x*k))

        data.frame(x, y, model = "Arrhenius")
    }
}

###############################################################################
# plot fitted models onto the data
###############################################################################

# plot all models
models_plt <- function(id, dataframe, flsVals, nhsVals, nlsVals, cubicVals, arhVals){
    points <- subset(dataframe, NewID == id, select = c(UsedTempK, STVlogged))
    colnames(points) <- c("Temp", "Trait")

    suppressWarnings(models <- rbind(full_schfld(id, GRDF, flsVals),
                                     noh_schfld(id, GRDF, nhsVals),
                                     nol_schfld(id, GRDF, nlsVals),
                                     cubic(id, GRDF, cubicVals),
                                     arrhenius(id, GRDF, arhVals)))
    models <- na.omit(models)
    rownames(models) <- NULL
    colnames(models) <- c("Temp", "Trait", "model")
    models$Temp <- as.numeric(models$Temp)
    models$Trait <- as.numeric(models$Trait)

    plt <- ggplot(models, aes(Temp, Trait))
    plt <- plt + geom_line(aes(color = model, linetype = model))
    plt <- plt + geom_point(data = points)
    plt <- plt + theme_classic()
    plt <- plt + theme(legend.position = "bottom")
    plt <- plt + xlab("Temperature (K)")
    plt <- plt + ylab("Logged Trait Value")
    return(plt)
}

# models_plt(3, GRDF, flschDF, nhschDF, nlschDF, cubicDF)

###############################################################################
# summary tables of NLLS outputs
###############################################################################

my_theme <- ttheme_minimal(base_size = 10, base_colour = "black",
                           base_family = "", parse = FALSE,
                           padding = unit(c(4, 4), "mm"))

# table summaring results of NLLS for schoolfield models
sch_tbl <- function(id, flsch, nhsch, nlsch){
    full <- subset(flsch, NewID == id)
    full$model <- "Full"
    if (is.na(full$chisqr)){
        full$B0 <- NA
        full$E  <- NA
        full$Eh <- NA
        full$El <- NA
        full$Th <- NA
        full$Tl <- NA
    }

    noh  <- subset(nhsch, NewID == id)
    noh$model <- "noh"
    if (is.na(noh$chisqr)){
        noh$B0 <- NA
        noh$E  <- NA
        noh$El <- NA
        noh$Tl <- NA
    }

    nol  <- subset(nlsch, NewID == id)
    nol$model <- "nol"
    if (is.na(nol$chisqr)){
        nol$B0 <- NA
        nol$E  <- NA
        nol$Eh <- NA
        nol$Th <- NA
    }

    sch  <- bind_rows(full, noh, nol)
    sch  <- sch[c("model", "B0", "E", "Eh", "El", "Th", "Tl", "aic", "bic",
                  "chisqr")]
    rownames(sch) <- NULL
    tableGrob(format(sch, digits = 5), theme = my_theme)
}

# table summaring results of NLLS for cubic model
cub_tbl <- function(id, cubm){
    cub <- subset(cubm, NewID == id)
    cub$model <- "cubic"
    cub <- cub[c("model", "a", "b", "c", "d", "aic", "bic", "chisqr")]
    rownames(cub) <- NULL
    tableGrob(format(cub, digits = 5), theme = my_theme)
}


arh_tbl <- function(id, arhm){
    arh <- subset(arhm, NewID == id)
    arh$model <- "arrhenius"
    arh <- arh[c("model", "A0", "Ea", "deltaCp", "deltaH", "trefs",  "aic", "bic", "chisqr")]
    rownames(arh) <- NULL
    tableGrob(format(arh, digits = 5), theme = my_theme)
}

# sch_tbl(3, flschDF, nhschDF, nlschDF)
# cub_tbl(3, cubicDF)

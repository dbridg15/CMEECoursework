#!usr/bin/env Rscript

# script: plotfuncs.R
# Desc:   R functions for plotting thermal performance curves with a number of
#         fitted models curves overlaid and tables containing parameter values
#         and curve statistics
#         Also has function for comparing results of model fitting
# Author: David Bridgwood (dmb2417@ic.ac.uk)

# imports
suppressPackageStartupMessages(require(ggplot2))
suppressPackageStartupMessages(require(dplyr))
suppressPackageStartupMessages(require(gridExtra))
suppressPackageStartupMessages(require(tidyr))

###############################################################################
# constants
###############################################################################

k <- 8.6173303e-05  # Boltzmann's contant in eV K^-1
e <- exp(1)

###############################################################################
# basic plots
###############################################################################

# basic plot of Trait Value by Temp (K)
basic_plt <- function(id, dataframe){

  tmp <- subset(dataframe, NewID == id)

  plt <- ggplot(data = tmp, aes(UsedTempK, OriginalTraitValue))
  plt <- plt + geom_point()
  plt <- plt + theme_classic()
  return(plt)
}

# plot of logged trait value by 1/kT with linear fits through left and right
# side of curve (slopes equal Eh and E respectivley)
KT_plt <- function(id, dataframe){

  tmp <- subset(dataframe, NewID == id)

  plt <- ggplot(data = tmp, aes(adjTemp, OTVlogged))
  plt <- plt + geom_point()
  plt <- plt + theme_classic()

  # add lines with given slope and intercept calculated with starting values
  plt <- plt + geom_abline(slope = tmp$E[1], intercept = tmp$Eint[1],
                           lty = 6, color = "red")
  plt <- plt + geom_abline(slope = tmp$Eh[1], intercept = tmp$Ehint[1],
                           lty = 6, color = "green")

  # line segments to show how starting B0 was calculated
  plt <- plt + geom_segment(x = -10000, xend = (1/(283.15*k)),
                            y = log(tmp$B0[1]), yend = log(tmp$B0[1]),
                            lty = 5, color = "blue")
  plt <- plt + geom_segment(x = (1/(283.15*k)), xend = (1/(283.15*k)),
                            y = -10000, yend = log(tmp$B0[1]),
                            lty = 5, color = "blue")
  plt <- plt + xlab("1/kT")
  plt <- plt + ylab("Logged Trait Value")
  return(plt)
}


###############################################################################
# model x and y from NLLS output
###############################################################################

# *** the below functions all have these three inputs ***
  # id     = curve id
  # data   = dataframe containing curve data
  # values = dataframe containg output from NLLS for model

# they all return a data frame with 100 x values (between min and max temp) and
# corresponding y values - 100 points for smooth line when plotting


# return x and y values from full schoolfield model using values from NLLS
full_schfld <- function(id, data, values){

  if (is.na(subset(values, NewID == id)$chisqr)){
    # print("Full Schoolfield did not converge")
  } else {
    # create sequence of length 100 from min to max temperature
    x <- subset(data, NewID == id)$UsedTempK
    x <- seq(min(x), max(x), length.out = 100)

    # get parameter values from NLLS output
    B0 <- subset(values, NewID == id)$B0
    E  <- subset(values, NewID == id)$E
    Eh <- subset(values, NewID == id)$Eh
    El <- subset(values, NewID == id)$El
    Th <- subset(values, NewID == id)$Th
    Tl <- subset(values, NewID == id)$Tl

    # put sequence through model to get predicted trait values
    y <- log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                  1+(e**((El/k)*((1/Tl)-(1/x))))+(e**((Eh/k)*((1/Th)-(1/x))))))
    data.frame(x, y, model = "Full Schoolfield")  # return as dataframe
  }
}


# return x and y values from noh schoolfield model using values from NLLS
noh_schfld <- function(id, data, values){

  if (is.na(subset(values, NewID == id)$chisqr)){
    # print("No high Schoolfield did not converge")
  } else {
    # create sequence of length 100 from min to max temperature
    x <- subset(data, NewID == id)$UsedTempK
    x <- seq(min(x), max(x), length.out = 100)

    # get parameter values from NLLS output
    B0 <- subset(values, NewID == id)$B0
    E  <- subset(values, NewID == id)$E
    El <- subset(values, NewID == id)$El
    Tl <- subset(values, NewID == id)$Tl

    # put sequence through model to get predicted trait values
    y <- log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(1+(e**((El/k)*((1/Tl)-(1/x))))))
    data.frame(x, y, model = "No High Schoolfield")  # return as dataframe
  }
}


# return x and y values from nol schoolfield model using values from NLLS
nol_schfld <- function(id, data, values){

  if (is.na(subset(values, NewID == id)$chisqr)){
    # print("no low schoolfield did not converge")
  } else {
    # sequence of length 100 from min to max temperature
    x <- subset(data, NewID == id)$UsedTempK
    x <- seq(min(x), max(x), length.out = 100)

    # get parameter values from NLLS output
    B0 <- subset(values, NewID == id)$B0
    E  <- subset(values, NewID == id)$E
    Eh <- subset(values, NewID == id)$Eh
    Th <- subset(values, NewID == id)$Th

    # put seqeuce through model
    y <- log((B0*e**((-E/k)*((1/x)-(1/283.15))))/(
                                         1+(e**((Eh/k)*((1/Th)-(1/x))))))
    data.frame(x, y, model = "No Low Schoolfield")  # return as dataframe
  }
}


# return x and y values from cubic model using values from NLLS
cubic <- function(id, data, values){

  if (is.na(subset(values, NewID == id)$chisqr)){
    # print("Cubic model did not converge")
  } else {
    # sequence if length 100 from min to max temp (not in C not K as NLLS was
    # done on C
    x <- subset(data, NewID == id)$UsedTemp
    x <- seq(min(x), max(x), length.out = 100)

    # get parameter values from NLLS output
    a <- subset(values, NewID == id)$a
    b <- subset(values, NewID == id)$b
    c <- subset(values, NewID == id)$c
    d <- subset(values, NewID == id)$d

    # put sequence through model
    y <- a + b*x + c*x^2 + d*x^3

    x <- x + 273.15  # convert x values to kelvin for plotting
    y <- log(y)      # log y values for plotting

    data.frame(x, y, model = "Cubic")  # return as dataframe
  }
}


# return x and y values from arrhenius model using values from NLLS
arrhenius <- function(id, data, values){

   if (is.na(subset(values, NewID == id)$chisqr)){
     # print("Cubic model did not converge")
   } else {
     # sequence of length 100 from min to max temperature
     x <- subset(data, NewID == id)$UsedTempK
     x <- seq(min(x), max(x), length.out = 100)

     # get parameter values from NLLS output
     A0      <- subset(values, NewID == id)$A0
     Ea      <- subset(values, NewID == id)$Ea
     deltaCp <- subset(values, NewID == id)$deltaCp
     deltaH  <- subset(values, NewID == id)$deltaH
     trefs   <- subset(values, NewID == id)$trefs

     # put sequence through model
     y <- log(A0)-((Ea-deltaH*(1-x/trefs)-deltaCp*(x-trefs-x*log(x/trefs)))/(x*k))

     data.frame(x, y, model = "Arrhenius")  # return as dataframe
 }
}

###############################################################################
# plot fitted models onto the data
###############################################################################

# plot actual points from data and lines for each model which converged
# function inputs
  # id        = specific curve id
  # dataframe = dataframe with data for curves
  # flsVals   = dataframe with NLLS output for full_scholfield_model
  # nhsVals   = dataframe with NLLS output for noh_scholfield_model
  # nlsVals   = dataframe with NLLS output for nol_scholfield_model
  # cubicVals = dataframe with NLLS output for cubic_model
  # arhVals   = dataframe with NLLS output for arrhenius_model

models_plt <- function(id, dataframe, flsVals, nhsVals, nlsVals, cubicVals, arhVals){
  # data points for curve x = temperature (K), y = logged trait value
  points <- subset(dataframe, NewID == id, select = c(UsedTempK, OTVlogged))
  colnames(points) <- c("Temp", "Trait")

  # rbind the dataframes which are output from the model functions (100 x and
  # y values) suppressWarnings used as NAs are produced when the curves do
  # not converge
  suppressWarnings(models <- rbind(full_schfld(id, GRDF, flsVals),
                                   noh_schfld(id, GRDF, nhsVals),
                                   nol_schfld(id, GRDF, nlsVals),
                                   cubic(id, GRDF, cubicVals),
                                   arrhenius(id, GRDF, arhVals)))
  models <- na.omit(models)  # remove NAs (models which did not converge)
  rownames(models) <- NULL   # get rid of row names (which mess with ggplot)
  colnames(models) <- c("Temp", "Trait", "model")
  models$Temp  <- as.numeric(models$Temp)
  models$Trait <- as.numeric(models$Trait)

  plt <- ggplot(models, aes(Temp, Trait))
  plt <- plt + geom_line(aes(color = model, linetype = model))
  plt <- plt + geom_point(data = points)  # add the data points from the points df
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

# set up theme for summary tables (smaller text minimal lines)
my_theme <- ttheme_minimal(base_size = 10, base_colour = "black",
                           base_family = "", parse = FALSE,
                           padding = unit(c(4, 4), "mm"))

# table summaring results of NLLS for schoolfield models
  # id    = specific curve id
  # flsch = output from NLLS for full_scholfield_model
  # nhsch = output from NLLS for noh_scholfield_model
  # nlsch = output from NLLS for noh_scholfield_model

sch_tbl <- function(id, flsch, nhsch, nlsch){
  full <- subset(flsch, NewID == id)
  full$model <- "Full"
  if (is.na(full$chisqr)){  # if model didnt converge set all to NA
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
  sch  <- sch[c("model", "B0", "E", "Eh", "El", "Th", "Tl", "Rsqrd", "nlRsqrd",
                "nlaic")]
  rownames(sch) <- NULL
  # output dataframe as a grob which can be plotted alongside ggplot with gridExtra
  tableGrob(format(sch, digits = 5), theme = my_theme)
}

# table summaring results of NLLS for cubic model
cub_tbl <- function(id, cubm){
  cub <- subset(cubm, NewID == id)
  cub$model <- "cubic"
  cub <- cub[c("model", "a", "b", "c", "d", "nlaic", "Rsqrd")]
  rownames(cub) <- NULL
  tableGrob(format(cub, digits = 5), theme = my_theme)
}

# table summaring results of NLLS for enyme assisted arrhenius model
arh_tbl <- function(id, arhm){
  arh <- subset(arhm, NewID == id)
  arh$model <- "arrhenius"
  arh <- arh[c("model", "A0", "Ea", "deltaCp", "deltaH", "trefs",  "Rsqrd",
               "nlRsqrd", "nlaic")]
  rownames(arh) <- NULL
  tableGrob(format(arh, digits = 5), theme = my_theme)
}

# sch_tbl(3, flschDF, nhschDF, nlschDF)
# cub_tbl(3, cubicDF)

###############################################################################
# comparing AIC  functions
###############################################################################

# calculate delta AIC
delta <- function(row, model){
  abs(min(row, na.rm = TRUE) - row[model])
}

# calculate AIC weight
weight <- function(row, model_delta, comparing){
  if (is.na(row[model_delta])){
    0
  } else {
    exp(-.5*row[model_delta])/sum(exp(-.5*row[comparing]), na.rm = TRUE)
  }
}

# compare function... takes vector of models to compare
# returns either
    # aicDF - aic_delta aic_passed and aic_weight for each model
    # pltDF - like aicDF but melted by model for easy plotting with
    #         ggplot/doing anovas
    # plt   - boxplot of weights...

compare <- function(models, rtrn = "aicDF"){

  # vectors to indirectly refer to model dfs and columns...
  DFaic    <- paste0(models, "DF$nlaic")
  DFdelta  <- paste0(models, "_delta")
  DFweight <- paste0(models, "_weight")
  DFpass   <- paste0(models, "_pass")


  # make df - NewID column taken from cubicDF$NewID column
  aicDF <- data.frame("NewID" = eval(parse(text = (paste0(models[1], "DF$NewID")))))

  # now add aic columns for each included model
  for (i in 1:length(models)){
    aicDF <- cbind(aicDF, eval(parse(text = DFaic[i])))
  }

  colnames(aicDF) <- c("NewID", models)

  # apply delta function
  for (i in 1:length(models)){
    aicDF[DFdelta[i]] <- apply(aicDF, 1, delta, model = models[i])
  }

  # apply weight function
  for (i in 1:length(models)){
    aicDF[DFweight[i]] <- apply(aicDF, 1, weight, model_delta = DFdelta[i],
                                comparing = DFdelta)
  }

  # see if they pass. delta < 2
  for (i in 1:length(models)){
    aicDF[DFpass[i]] <- eval(parse(text = (paste0("aicDF$", DFdelta[i])))) <= 2
  }

  cat("\nBased off of delta when < 2 from minimum aic means models are comparable\n\n")

  for (i in 1: length(models)){
    passed <- sum(eval(parse(text = (paste0("aicDF$", DFpass[i])))), na.rm = TRUE)

    cat(paste0(models[i], ": ", passed, " (", round((passed/nrow(aicDF))*100, 2),
               "%) curves best or comparable to best\n"))
  }

  # make pltDF (basically melting but i couldnt figure out how to do it with dplyr
  pltDF <- data.frame(NewID  = aicDF$NewID, model = models[1],
                      aic    = eval(parse(text = DFaic[1])),
                      delta  = eval(parse(text = paste0("aicDF$",DFdelta[1]))),
                      weight = eval(parse(text = paste0("aicDF$",DFweight[1]))))

  for(i in 2:length(models)){
    pltDF <- rbind.data.frame(pltDF,
                   data.frame(NewID  = aicDF$NewID, model = models[i],
                              aic    = eval(parse(text = DFaic[1])),
                              delta  = eval(parse(text = paste0("aicDF$",DFdelta[i]))),
                              weight = eval(parse(text = paste0("aicDF$",DFweight[i])))))
  }

  # boxplot of weights
  plt <- ggplot(data = pltDF, aes(y = weight, x = model))
  plt <- plt + geom_boxplot(outlier.shape=NA, lwd = .3)
  plt <- plt + geom_jitter(position=position_jitter(width=.3, height=0), alpha = 0.3, cex = .1)
  plt <- plt + stat_summary(fun.y=mean, geom="point", shape=18, size=2.5, show.legend = FALSE)
  plt <- plt + theme_classic()
  # print(plt)

  # anova and tukeyHSD
  fit <- aov(weight ~ model, data = pltDF)

  cat("\n\nNow looking at weighted aic\n\n")
  print(TukeyHSD(fit))

  # return what i want
  if (rtrn == "aicDF"){
    return(aicDF)
  } else if (rtrn == "pltDF"){
      return(pltDF)
  } else {
      return(plt)
  }
}

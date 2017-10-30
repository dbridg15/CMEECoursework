rm(list = ls())

###############################################################################
# sws1 - basic R
###############################################################################

# setting working directories
# getwd()
# setwd("~/cmeecoursework/Week4/Code")
# getwd()

# R as a basic calculator

2*2+1

12/2^3

# assigning values to variables

x <- 5
y <- 17

x + y

x2 <- x^2

z <- sqrt(x2)

# logical tests

x < y

3 <= 3

# vectors

myNumericVector <- c(1.3, 2.5, 6.4, 1.2, 5.6, 3.1, 2.9)
myCharacterVector <- c("low", "low", "low", "high", "high", "high")
MyLogicalVecotr <- c(T, T, T, F, F, T, F, T, F, F ,T, T, F, T)

# str() gives the structure of a variable

str(myNumericVector)

# vectors should always be one type!

myMixedVector <- c(1, 4, T, F, "yelp", "chicken", 7)
str(myMixedVector)  # coerced to character!

# installing packages

# install.packages("broom")
# library(broom)
# require(broom)

# when you need help ask R for it!

# help(str)
# ?log

# reading in data

# point to file, header = T makes top row be header names
d <- read.table("../Data/SparrowSize.txt", header = T)

# clearing objects

rm(list = ls())

###############################################################################
# sws2 describing distributions
###############################################################################

# read in the data
d <- read.table("../Data/SparrowSize.txt", header = T)

str(d)  # whats the structure of d

names(d)  # column names

head(d)  # top few rows of the data

# exploring the data

length(d$Tarsus)  # how many rows are there

hist(d$Tarsus)  # plot a hist

mean(d$Tarsus)  # gives NA!

mean(d$Tarsus, na.rm = T)  # if NAs are present they must be removed

median(d$Tarsus, na.rm = T)

mode(d$Tarsus, na.rm = T)  # tells us the data is numeric because the mode on a
                           # numeric dataset is a bit pointless

# plotting histograms in a grid
par(mfrow = c(2, 2))
# different bin widths make a big difference!!
hist(d$Tarsus, breaks = 3, col = "grey")
hist(d$Tarsus, breaks = 10, col = "grey")
hist(d$Tarsus, breaks = 30, col = "grey")
hist(d$Tarsus, breaks = 100, col = "grey")


# using modeest

require("modeest")

mlv(d$Tarsus)  # doesnt work because the data has NA's

# create a new dataframe with only rows that have a value for Tarsus
d2 <- subset(d, d$Tarsus != "NA")

length(d$Tarsus)
length(d2$Tarsus)

mlv(d2$Tarsus)  # this a prediction of the mode from numeric values

# range, varience and standard deviation

boxplot(d2$Tarsus)  # good to see the spread of the data

range(d$Tarsus)  # need to use na.rm = T or...

range(d2$Tarsus)

var(d2$Tarsus)  # sd squared!

# long hand varience...

sum((d2$Tarsus - mean(d2$Tarsus))^2)/(length(d2$Tarsus) - 1)

sqrt(var(d2$Tarsus))


# mean, var and sd of Tarus, Bill, Mass and Wing

mean(d$Tarsus, na.rm = T)
var(d$Tarsus, na.rm = T)
sd(d$Tarsus, na.rm = T)

mean(d$Bill, na.rm = T)
var(d$Bill, na.rm = T)
sd(d$Bill, na.rm = T)

mean(d$Mass, na.rm = T)
var(d$Mass, na.rm = T)
sd(d$Mass, na.rm = T)

mean(d$Wing, na.rm = T)
var(d$Wing, na.rm = T)
sd(d$Wing, na.rm = T)


# histograms

par(mfrow = c(2, 2))
hist(d$Tarsus, main = "Tarsus")
hist(d$Bill, main = "Bill")
hist(d$Mass, main = "Mass")
hist(d$Wing, main = "Wing")

# z-score and quantiles

# z-standardising the data transforms it so you have a mean of 0 and a sd of 1

zTarsus <- (d2$Tarsus - mean(d2$Tarsus))/sd(d2$Tarsus)
mean(zTarsus)
var(zTarsus)
sd(zTarsus)
hist(zTarsus)

# but you can do it in R too!

znormal <- rnorm(1000000)
hist(znormal, breaks = 100)
summary(znormal)  # summarises the data!


# qnorm gives the quantiles from a probability distribution (mean = 0, sd = 1)
# returns then number whose cumulative distribution matched the given
# probability
qnorm(c(0.025, 0.975))
qnorm(c(0.05, 0.95))

# pnorm calculates the probabilty that a normally distributed random number
# will be less than the number given
pnorm(c(0.025, 0.975))

par(mfrow = c(1, 2))
hist(znormal, breaks = 100)
abline(v = qnorm(c(0.25, 0.5, 0.75)), lwd = 2)
abline(v = qnorm(c(0.025, 0.975)), lwd = 2, lty = "dashed")
plot(density(znormal))
abline(v = qnorm(c(0.25, 0.5, 0.75)), col = "gray")
abline(v = qnorm(c(0.025, 0.975)), lwd = 2, lty = "dotted", col = "black")
abline(h = 0, lwd = , col = "blue")
text(2, 0.3, "1.96", col = "red", adj = 0)
text(-2, 0.3, "-1.96", col = "red", adj = 1)

# 95% confidence intervals!!

boxplot(d$Tarsus~d$Sex.1, col = c("Red", "Blue"), ylab = "Tarsus length (mm)")

# middle line is the median
# box is the interquartle range
# the whiskers are 1.5*IQR from the box

# sum of squares (SS) is the sum of the squares of all the deviations from the
# mean

rm(list = ls())

###############################################################################
# sws3 data types
###############################################################################

# data types
    # data can be numeric of catergorical
    # discrete of continuous

# CONTINUOUS NUMERIC

    # normal distribution
        # probabiltiy distribution defined by the mean and the varience

    # z-distribution
        # this is a normal distribution which has a mean of 0 and a sd of 1


    # log normal
        # mesurements cannont be negative
        # there is a positive relationship between the mean and the varience

    # Exponentail distribution
        # usually something (population) over a time-period


# DISCRETE NUMERIC

    # 0's and 1's representing binomial states (i.e. male and female)

    # count data - how many offspring, trees in a forest
        # poisson distribution
        # negative binomial?

# CATERGORICAL DATA

    # can be nominal or ranked

# examples in R

d <- read.table("../Data/SparrowSize.txt", header = T)

# what sort of data

print("BirdID data is discrete numeric")
head(d$BirdID)
hist(d$BirdID)
plot(density(d$BirdID, na.rm = T))

print("year data is discrete numeric")  # not completely sure!!
head(d$Year)
hist(d$Year)
plot(density(d$Year, na.rm = T))

print("Tarsus data is continuous numeric")
head(d$Tarsus)
hist(d$Tarsus)
plot(density(d$Tarsus, na.rm = T))

print("Bill data is continuous numeric")
head(d$Bill)
hist(d$Bill)
plot(density(d$Bill, na.rm = T))

print("Wing data is continuous numeric")
head(d$Wing)
hist(d$Wing)
plot(density(d$Bill, na.rm = T))

print("Mass data is continuous numeric")
head(d$Mass)
hist(d$Mass)
plot(density(d$Mass, na.rm = T))

# r functions to draw different distributions!

# gaussian (normal distribution)
hist(rnorm(1000))
plot(density(rnorm(1000)))

# poisson distribution
hist(rpois(1000, 4))
plot(density(1000, 4))

# bit lost on binomial
hist(sample(0:1, 1000, replace = T))
plot(density((sample(0:1, 1000, replace = T))))

# random!
hist(runif(10000))
plot(density(runif(10000))

rm(list = ls())

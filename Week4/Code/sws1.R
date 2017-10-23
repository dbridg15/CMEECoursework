###############################################################################
# Stats with Sparrows 1
###############################################################################

# variable creation

x <- 6
y <- 5

z <- x*y

# logiacal stuff

3 > 2

3 >= 3

4 < 2

# vectors

myNumericVector <- c(1.3, 2.5, 6.4, 1.2, 5.6, 3.1, 2.9)
myCharacterVector <- c("low", "low", "low", "high", "high", "high")
MyLogicalVecotr <- c(T, T, T, F, F, T, F, T, F, F ,T, T, F, T)

# r notation

sqrt(4)

4^0.5

log(0)

log(inf)

# clear workspace

rm(list = ls())

# reading in data

d <- read.table("../Data/SparrowSize.txt", header = T)

str(d)


rm(list = ls())

###############################################################################
# stats with sparrows 2
###############################################################################


d <- read.table("../Data/SparrowSize.txt", header = T)

str(d)

names(d)

head(d)

# exploring the data

length(d$Tarsus)

hist(d$Tarsus)

mean(d$Tarsus)  # gives NA!

mean(d$Tarsus, na.rm = T)

median(d$Tarsus, na.rm = T)

mode(d$Tarsus, na.rm = T)  # tells us the data is numeric because the mode on a
                           # numeric dataset is a bit pointless


par(mfrow = c(2, 2))
hist(d$Tarsus, breaks = 3, col = "grey")
hist(d$Tarsus, breaks = 10, col = "grey")
hist(d$Tarsus, breaks = 30, col = "grey")
hist(d$Tarsus, breaks = 100, col = "grey")


# using modeest

require("modeest")

mlv(d$Tarsus)  # doesnt work because the data has NA's

d2 <- subset(d, d$Tarsus != "NA")

length(d$Tarsus)
length(d2$Tarsus)

mlv(d2$Tarsus)

# range, varience and standard deviation

boxplot(d2$Tarsus)

range(d$Tarsus)

range(d2$Tarsus)

var(d2$Tarsus)

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



# Z-scores and quantiles

zTarsus <- (d2$Tarsus - mean(d2$Tarsus))/sd(d2$Tarsus)
var(zTarsus)
sd(zTarsus)
hist(zTarsus)

zTarus2 <- scale(d2$Tarsus, center = T, scale = T)
var(zTarus2)

# z normal

set.seed(123)
znormal <- rnorm(1e+06)
hist(znormal, breaks = 100)

summary(znormal)
pnorm(.Last.value)

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


boxplot(d$Tarsus~d$Sex.1, col = c("red", "blue"), ylab = "Tarsus length (mm)")

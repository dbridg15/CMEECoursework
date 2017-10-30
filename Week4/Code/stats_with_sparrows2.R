rm(list = ls())

###############################################################################
# sws4 standard errors
###############################################################################

d <- read.table("../Data/SparrowSize.txt", header = T)
d1 <- subset(d, !is.na(d$Tarsus))
d2001 <- subset(d, d$Year == 2001)

# function to calculate standard error
std.error <- function(x){
    sqrt(var(x[!is.na(x)])/length(x[!is.na(x)]))
}

# function to calculate 95% confidence limits
cnf.lm <-function(x){
    left <- mean(x[!is.na(x)]) - 1.96*std.error(x)
    right <- mean(x[!is.na(x)]) + 1.96*std.error(x)
    y  <- c(left, right)
    return (y)
}


# standard errors! and confidence intervals
sum(!is.na(d$Tarsus))
std.error(d$Tarsus)
cnf.lm(d$Tarsus)
sum(!is.na(d2001$Tarsus))
std.error(d2001$Tarsus)
cnf.lm(d2001$Tarsus)

sum(!is.na(d$Mass))
std.error(d$Mass)
cnf.lm(d$Mass)
sum(!is.na(d2001$Mass))
std.error(d2001$Mass)
cnf.lm(d2001$Mass)

sum(!is.na(d$Wing))
std.error(d$Wing)
cnf.lm(d$Wing)
sum(!is.na(d2001$Wing))
std.error(d2001$Wing)
cnf.lm(d2001$Wing)

sum(!is.na(d$Bill))
std.error(d$Bill)
cnf.lm(d$Bill)
sum(!is.na(d2001$Bill))
std.error(d2001$Bill)
cnf.lm(d2001$Bill)


###############################################################################
# sws5 hypothesis testing
###############################################################################

# boxplot to explore hypothesis that males and females have different masses

boxplot(d$Mass~d$Sex.1, col = c("red", "blue"), ylab = "Body Mass (g)")
# looks promising...

t.test1 <- t.test(d$Mass~d$Sex.1)
t.test1

#
# 	Welch Two Sample t-test
#
# data:  d$Mass by d$Sex.1
# t = -5.5654, df = 1682.9, p-value = 3.039e-08
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -0.7669117 -0.3672162
# sample estimates:
# mean in group female   mean in group male
#             27.46852             28.03558
#

# how much precision do you loose when you reduce the number of observations

d2 <- as.data.frame(head(d, 50))

t.test2 <- t.test(d2$Mass~d2$Sex.1)
t.test2

#
# 	Welch Two Sample t-test
#
# data:  d2$Mass by d2$Sex.1
# t = 0.33484, df = 26.84, p-value = 0.7403
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -0.9361255  1.3011254
# sample estimates:
# mean in group female   mean in group male
#              27.5200              27.3375
#

# differences in wing length for 2001 and overall

d2001 <- subset(d, d$Year == 2001)

t.test(d$Wing, d2001$Wing)
#
# 	Welch Two Sample t-test
#
# data:  d$Wing and d2001$Wing
# t = -1.0919, df = 107.58, p-value = 0.2773
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -0.7054671  0.2043338
# sample estimates:
# mean of x mean of y
#  77.40206  77.65263
#
# there is no statistically significant differences between the wing length for
# 2001 and the whole dataset


# differences in mass for 2001 males and females

t.test(d2001$Mass~d2001$Sex)
#
# 	Welch Two Sample t-test
#
# data:  d2001$Mass by d2001$Sex
# t = -1.9568, df = 94.993, p-value = 0.05331
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -1.379772935  0.009962672
# sample estimates:
# mean in group 0 mean in group 1
#        27.11047        27.79537
#
# The difference is not statistically significant when looking only at 2001


# difference in wing length between males and females

t.test(d$Wing~d$Sex.1)
#
# 	Welch Two Sample t-test
#
# data:  d$Wing by d$Sex.1
# t = -25.402, df = 1692.9, p-value < 2.2e-16
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -2.731405 -2.339840
# sample estimates:
# mean in group female   mean in group male
#             76.09611             78.63173
#
# yes there is a statistically significant difference!


###############################################################################
# sws6 statistical power
###############################################################################

require(pwr)

# how many birds would you have to sample to detect a difference of an effect
# size of 5mm
pwr.t.test(d=(0-5)/sd(d$Wing, na.rm = T), power = .8,
           sig.level = .05, type = "two.sample",
           alternative = "two.sided")

###############################################################################
# sws7 degrees of freedom
###############################################################################

# more degrees of freedom!
# a dataset of 100 birds with a 2-sample t-test because...


###############################################################################
# sws8 linear functions
###############################################################################

# How many df's for a line?
# going through (0,0)?
# with a slope of 1?

###############################################################################
# sws9 linear models
###############################################################################

y <- c(5, 4, 7, 9, 3)
x <- c(3, 1, 4, 8, 2)


plot(x,y)

model1 <- lm(y~x)
model1
summary(model1)
anova(model1)
resid(model1)
cov(x,y)
var(x)
plot(y~x)
abline(model1)

###############################################################################
# sws10 hypothesis testing and linear models
###############################################################################

rm(list = ls())

d <- read.table("../Data/SparrowSize.txt", header = T)

require(ggplot2)

# mass and tarsus
plot(d$Mass~d$Tarsus, xlab = "Mass (g)",
     ylab = "Tarsus length (mm)",
     pch = 19, cex = 0.4)

# making a perfect model!!
x <- c(1:100)
b <- 0.5
m <- 1.5
y <- m*x + b
plot(x, y, xlim = c(0,100), ylim = c(0, 100), pch = 19, cex = 0.5)

# back to mass and tarsus
plot(d$Mass~d$Tarsus, xlab = "Mass (g)",
     ylab = "Tarsus length (mm)",
     pch = 19, cex = 0.4,
     ylim = c(-5,38), xlim = c(0,22))

d1 <- subset(d, !is.na(d$Mass))
d2 <- subset(d1, !is.na(d1$Tarsus))
length(d2$Tarsus)

# linear model
model1 <- lm(Mass~Tarsus, data = d2)
summary(model1)  # summary of the model
hist(model1$residuals)  # spread of the error
head(model1$residuals)

# back to the perfect model...
model2 <- lm(y~x)
summary(model2)

# and back to the sparrow data
# z-standardize the data now the y-intercept will be the mean Tarsus
d2$z.Tarsus <- scale(d2$Tarsus)
model3 <- lm(Mass~z.Tarsus, data = d2)
summary(model3)

plot(d2$Mass~d2$z.Tarsus)
abline(v = 0, lty = "dotted")
abline(model3)

# lm instead of a t-test

d$Sex <- as.numeric(d$Sex)

par(mfrow = c(1, 2))
plot(d$Wing~d$Sex.1, ylab = "Wing (mm)")
plot(d$Wing~d$Sex, xlab = "Sex", xlim = c(-0.1, 1.1), ylab = "")
abline(lm(d$Wing~d$Sex), lwd = 2)
text(0.15, 76, "intercept")
text(0.9, 77.5, "slope", col = "red")

d4 <- subset(d, !is.na(d$Wing))
m4 <- lm(Wing~Sex, data = d4)
t4 <- t.test(d4$Wing~d4$Sex, var.equal = T)
summary(m4)
#
# Call:
# lm(formula = Wing ~ Sex, data = d4)
#
# Residuals:
#      Min       1Q   Median       3Q      Max
# -16.0961  -1.0961  -0.0961   1.3683   5.3683
#
# Coefficients:
#             Estimate Std. Error t value Pr(>|t|)
# (Intercept) 76.09611    0.07175 1060.50   <2e-16 ***
# Sex          2.53562    0.09998   25.36   <2e-16 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
# Residual standard error: 2.057 on 1693 degrees of freedom
# Multiple R-squared:  0.2753,	Adjusted R-squared:  0.2749
# F-statistic: 643.1 on 1 and 1693 DF,  p-value: < 2.2e-16
#

t4
#
#	Two Sample t-test
#
# data:  d4$Wing by d4$Sex
# t = -25.36, df = 1693, p-value < 2.2e-16
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -2.731727 -2.339518
# sample estimates:
# mean in group 0 mean in group 1
#        76.09611        78.63173
#

# linear model diagnostics

par(mfrow = c(2,2))
plot(model3)

par(mfrow = c(2, 2))
plot(m4)

# testing bill length and mass

d5 <- subset(d, !is.na(d$Bill))
d5 <- subset(d5, !is.na(d5$Mass))

model <- lm(d5$Mass~d5$Bill)

plot(d5$Mass~d5$Bill)
abline(model)


summary(model)
#
# Call:
# lm(formula = d5$Mass ~ d5$Bill)
#
# Residuals:
#     Min      1Q  Median      3Q     Max
# -6.3108 -1.4404 -0.1608  1.1637  8.3070
#
# Coefficients:
#             Estimate Std. Error t value Pr(>|t|)
# (Intercept) 16.59931    1.32732  12.506  < 2e-16 ***
# d5$Bill      0.83042    0.09964   8.334 2.28e-16 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
# Residual standard error: 1.981 on 1109 degrees of freedom
# Multiple R-squared:  0.05894,	Adjusted R-squared:  0.05809
# F-statistic: 69.46 on 1 and 1109 DF,  p-value: 2.281e-16
#

par(mfrow = c(2, 2))
plot(model)


# Explanatory variable os the Bill size and the response variable is the mass.

# COULD DO MORE IF YOU WANTED!!!

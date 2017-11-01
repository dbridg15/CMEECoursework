fm(list = ls())

###############################################################################
# sws11 maximum likelyhood
###############################################################################

# maximises the liklihood that the data you have comes from the model you
# assume

# e.g. 3 heads then 2 tails has a probability of

(0.5^3)*(0.5^2)
# [1] 0.03125

# we want to maximise the ML

# Bootstrapping --> resampling to get estimates

# sensetivity analysis --> systematically excluede dataset

###############################################################################
# sws12 covariance and correlation
###############################################################################

# covariance is hwo two variables change together
# the correlation coefficient is the covarience divided by the product of the
# standard deviations - standardized between -1 and 1

d <- read.table("../Data/SparrowSize.txt", header = T)
d1 <- subset(d, !is.na(d$Tarsus))
d1 <- subset(d1, !is.na(d1$Mass))


cov(d1$Tarsus, d1$Mass)
cor(d1$Tarsus, d1$Mass)

d1$Tarsus.cm  <- d1$Tarsus/10

cov(d1$Tarsus.cm, d1$Mass)
cor(d1$Tarsus.cm, d1$Mass)

# covariance is unit dependant while correlation is not!

###############################################################################
# sws13 more models
###############################################################################

rm(list = ls())

d <- read.table("../Data/SparrowSize.txt", header = T)
d1 <- subset(d, !is.na(d$Wing))

summary(d1$Wing)
hist(d1$Wing)

model1 <- lm(Wing~Sex.1, data = d1)
summary(model1)

boxplot(d1$Wing~d1$Sex.1, ylab = "Wing length (mm)")

anova(model1)
# Analysis of Variance Table
# 
# Response: Wing
#             Df Sum Sq Mean Sq F value    Pr(>F)    
# Sex.1        1 2722.0 2721.98  643.15 < 2.2e-16 ***
# Residuals 1693 7165.3    4.23                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


t.test(d1$Wing~d1$Sex.1, var.equal = T)
# 
# 	Two Sample t-test
# 
# data:  d1$Wing by d1$Sex.1
# t = -25.36, df = 1693, p-value < 2.2e-16
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#  -2.731727 -2.339518
# sample estimates:
# mean in group female   mean in group male 
#             76.09611             78.63173 
# 


# now looking at differences between individual birds!

boxplot(d1$Wing~d1$BirdID, ylab = "WIng length (mm)")

require(dplyr)

tbl_df(d1)
glimpse(d1)

d$Mass %>% cor.test(d$Tarsus, na.rm = T)
# 
# 	Pearson's product-moment correlation
# 
# data:  . and d$Tarsus
# t = 22.374, df = 1642, p-value < 2.2e-16
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  0.4454229 0.5195637
# sample estimates:
#       cor 
# 0.4833596 
# 


d1 %>%
    group_by(BirdID) %>%
    summarise(count=length(BirdID)) %>%
    count(count)


model3 <- lm(Wing~as.factor(BirdID), data = d1)
anova(model3)
# Analysis of Variance Table
# 
# Response: Wing
#                     Df Sum Sq Mean Sq F value    Pr(>F)    
# as.factor(BirdID)  617 8147.3 13.2047  8.1734 < 2.2e-16 ***
# Residuals         1077 1740.0  1.6156                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

boxplot(d$Mass~d$Year)

m2 <- lm(d$Mass~as.factor(d$Year))
anova(m2)
# Analysis of Variance Table
# 
# Response: d$Mass
#                     Df Sum Sq Mean Sq F value    Pr(>F)    
# as.factor(d$Year)   10  340.2  34.020  7.8866 1.721e-12 ***
# Residuals         1693 7303.0   4.314                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

summary(m2)
t(model.matrix(m2))


# subset not including year 2000

d2 <- subset(d, d$Year != 2000)

boxplot(Mass~Year, data = d2)
m4 <- lm(Mass~as.factor(Year), data = d2)
summary(m4)
anova(m4)
# Analysis of Variance Table
# 
# Response: Mass
#                   Df Sum Sq Mean Sq F value Pr(>F)
# as.factor(Year)    9   23.6  2.6243  0.6038 0.7947
# Residuals       1466 6372.0  4.3465               


###############################################################################
# sws14 repeatability and pitfalls
###############################################################################

# repeatability - how consistant something is within a group compared with the
# whole sample
# the ratio of among group varience over the total varience

# calculated with ANOVA output

rm(list = ls())

d <- read.table("../Data/SparrowSize.txt", header = T)
d1 <- subset(d, !is.na(d$Wing))

model3 <- lm(Wing~as.factor(BirdID), data = d1)
anova(model3)
# Analysis of Variance Table
# 
# Response: Wing
#                     Df Sum Sq Mean Sq F value    Pr(>F)    
# as.factor(BirdID)  617 8147.3 13.2047  8.1734 < 2.2e-16 ***
# Residuals         1077 1740.0  1.6156                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

require(dplyr)

d1 %>%
    group_by(BirdID) %>%
    summarise(count = length(BirdID))

d1 %>%
    group_by(BirdID) %>%
    summarise(count = length(BirdID)) %>%
    summarise(length(BirdID))

d1 %>%
    group_by(BirdID) %>%
    summarise(count = length(BirdID)) %>%
    summarise(sum(count))

d1 %>%
    group_by(BirdID) %>%
    summarise(count = length(BirdID)) %>%
    summarise(sum(count^2))

(1/617)*(1695-(7307/1695))
# [1] 2.740177

model3 <- lm(Wing~as.factor(BirdID), data = d1)
anova(model3)
# Analysis of Variance Table
# 
# Response: Wing
#                     Df Sum Sq Mean Sq F value    Pr(>F)    
# as.factor(BirdID)  617 8147.3 13.2047  8.1734 < 2.2e-16 ***
# Residuals         1077 1740.0  1.6156                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# so the repeatability is:

((13.2047-1.6156)/2.740177)/(1.6156+(13.2047-1.6156)/2.740177)
# [1] 0.7235893

# as a percentage
.Last.value*100

# Calculate the repeatabiltiy of body mass within individual birds. The N0 will
# be different fo redo dplyr stuff!!!


# d1 now removes NAs in mass
d1 <- subset(d, !is.na(d$Mass))


a <- d1 %>%
        group_by(BirdID) %>%
        summarise(count = length(BirdID)) %>%
        summarise(length(BirdID))

b <- d1 %>%
        group_by(BirdID) %>%
        summarise(count = length(BirdID)) %>%
        summarise(sum(count))

c <- d1 %>%
        group_by(BirdID) %>%
        summarise(count = length(BirdID)) %>%
        summarise(sum(count^2))




d <- (1/(a-1))*(b - (c/b))

model4 <- lm(Mass~as.factor(BirdID), data = d1)
anova(model4)
# Analysis of Variance Table
# 
# Response: Mass
#                     Df Sum Sq Mean Sq F value    Pr(>F)    
# as.factor(BirdID)  632 5589.3  8.8438  4.6117 < 2.2e-16 ***
# Residuals         1071 2053.9  1.9177                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


av <- anova(model4)

e <- av$"Mean Sq"[1]
f <- av$"Mean Sq"[2]

# the repeatabiltiy is...
((e-f)/d)/(f+(e-f)/d)

# as a %

.Last.value*100


###############################################################################
# sws15 linear models going big!!! (multiple linear models)
###############################################################################

# in multiple linear models there can be more than one explanatory variable
# you can even mix continuous and factor data

rm(list = ls())

daphnia <- read.delim("../Data/daphnia.txt")
summary(daphnia)

# testing for outliers
par(mfrow = c(1, 2))
plot(Growth.rate~Detergent, data = daphnia)
plot(Growth.rate~Daphnia, data = daphnia)

# there are no outliers as there are on circles in the boxplots!

require(dplyr)

daphnia %>%
    group_by(Detergent) %>%
    summarise(varience=var(Growth.rate))

daphnia %>%
group_by(Daphnia) %>%
summarise(varience=var(Growth.rate))

# is the data normally distributed?
hist(daphnia$Growth.rate)

# starting the model!

seFun <- function(x){
    sqrt(var(x)/length(x))
}

detergentMean <- with(daphnia, tapply(Growth.rate, INDEX = Detergent,
                                      FUN = mean))
detergentSEM <- with(daphnia, tapply(Growth.rate, INDEX = Detergent,
                                     FUN = seFun))
cloneMean <- with(daphnia, tapply(Growth.rate, INDEX = Daphnia, FUN = mean))
cloneSEM <- with(daphnia, tapply(Growth.rate, INDEX = Daphnia, FUN = seFun))

par(mfrow = c(2,1), mar = c(4, 4, 1, 1))
barMids <- barplot(detergentMean, xlab = "Detergent Type",
                   ylab = "Population growth rate",
                   ylim = c(0, 5))
arrows(barMids, detergentMean - detergentSEM, barMids, detergentMean +
       detergentSEM, code = 3, angle =90)
barMids <- barplot(cloneMean, xlab = "Daphnia clone",
                   ylab = "Population growth rate",
                   ylim = c(0, 5))
arrows(barMids, cloneMean - cloneSEM, barMids, cloneMean + cloneSEM,
       code = 3, angle = 90)


daphniaMod <- lm(Growth.rate~Detergent+Daphnia, data = daphnia)
anova(daphniaMod)
summary(daphniaMod)

detergentMean - detergentMean[1]
cloneMean - cloneMean[1]

daphniaANOVAMod <- aov(Growth.rate~Detergent + Daphnia, data = daphnia)
summary(daphniaANOVAMod)

daphniaModHSD <- TukeyHSD(daphniaANOVAMod)
daphniaModHSD

par(mfrow = c(2, 1), mar = c(4, 4, 1, 1))
plot(daphniaModHSD)

par(mfrow=c(2, 2))
plot(daphniaMod)

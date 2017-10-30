rm(list = ls())

###############################################################################
# Autocorrelation in weather
###############################################################################

# read in the data
load('../Data/KeyWestAnnualMeanTemperature.RData')

# explore the data
head(ats)
length(ats$Year)
ats[,1]
# hist(ats$Temp)
# boxplot(ats$Temp)

# start the analysis
y1 <- head(ats$Temp, length(ats$Year) -1)  # all but last year
y2 <- tail(ats$Temp, length(ats$Year) -1)  # all but first year

actual_cor <- cor(y1, y2)  # the actual correlation value!
actual_cor  # 0.3261697

# initialize empty vector for test correlations
test_cor <- vector(mode = 'numeric', length = 10000)

for(i in 1:10000){  # do 10000 times!
    ytmp <- sample(y2, replace = F)  # sample from years 1901:2000 randomly
    test_cor[i] <- cor(y1, ytmp)  # look at correlation...
}

# p.value is approximatley the fraction of correlation coefficients larger than
# the actual one!
aprx.p.value <- sum(test_cor > actual_cor)/100000
print(sum(test_cor > actual_cor))
print(aprx.p.value)

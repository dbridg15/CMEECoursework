#!usr/bin/env Rscript

# script: TAutocorr.R
# Desc: test correlation of temperature of pairs of years
# Author: David Bridgwood (dmb2417@ic.ac.uk)

rm(list = ls())

# required packages
require(ggplot2)

###############################################################################
# Autocorrelation in weather
###############################################################################

# read in the data
load('../Data/KeyWestAnnualMeanTemperature.RData')

# explore the data
# head(ats)
# length(ats$Year)
ats[,1]
# hist(ats$Temp)
# boxplot(ats$Temp)

# start the analysis
y1 <- head(ats$Temp, length(ats$Year) -1)  # all but last year
y2 <- tail(ats$Temp, length(ats$Year) -1)  # all but first year

DF <- data.frame(y1, y2)  # save into dataframe

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
print(aprx.p.value)  # consistantly < 0.001!!!!!

# make a pretty figure

pdf("../Results/TAutoCorr_figure.pdf")
    ggplot(DF, aes(x = y1, y = y2)) +
        geom_point() +
        geom_smooth(method = lm) +
        xlab("Mean Anunual Tempertaure Years 1900-1999 (°C)") +
        ylab("Mean Anunual Tempertaure Years 1901-2000 (°C)") +
        theme_classic()+
        theme(axis.text=element_text(size=16),
            axis.title=element_text(size=18))
dev.off()

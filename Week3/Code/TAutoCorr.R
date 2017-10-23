###############################################################################
# Autocorrelation in weather
###############################################################################

require(ggplot2)

load('../Data/KeyWestAnnualMeanTemperature.RData')

head(ats)
length(ats$Year)

qplot(x = ats$Year, y = ats$Temp)
hist(ats$Temp)
boxplot(ats$Temp)



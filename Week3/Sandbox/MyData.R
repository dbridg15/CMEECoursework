###############################################################################
# 7.11 Inporting and exporting
###############################################################################

# Read in data
MyData <- read.csv("../Data/trees.csv")
ls()
head(MyData)
str(MyData)
# Read in data with headers
MyData <- read.csv("../Data/trees.csv", header = T)
# Read in data specify seperator as ','
MyData <- read.csv("../Data/trees.csv", sep = ',', header = T)
# Read in data ignoring the top 5 lines
MyData <- read.csv("../Data/trees.csv", skip =5)


# Writing out and saving files

# write to csv
write.csv(MyData, "../Results/MyData.csv")
# append
write.table(MyData[1,], file = "../Results/MyData.csv", append = T )
# write row names
write.csv(MyData, "../Results/MyData.csv", row.names = T)
# ignore column names
write.csv(MyData, "../Results/MyData.csv", col.names = F)

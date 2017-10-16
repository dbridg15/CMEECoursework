# A simple R script to illustrate R input and OUtput
# Run line by line and check inputs/outputs to understand what is happening

MyData <- read.csv("../Data/trees.csv", header = TRUE)  # Import with headers

write.csv(MyData, "../Results/MyData.csv")  # Write out to a new file

write.table(MyData[1,], file = "../Results/MyData.csv", append = TRUE)  # Append to it

write.csv(MyData, "../Results/MyData.csv", row.names = TRUE)  # Write row names

write.table(MyData, "../Results/MyData.csv", col.names = FALSE)  # ignore column names


# apply: applying the same function to rows/columns of a matrix

# build a random matrix
M <- matrix(rnorm(100), 10, 10)

# take the mean of each row
RowMeans <- apply(M, 1, mean)
print(RowMeans)

# now the varience
RowVars <- apply(M, 1, var)
print(RowVars)

# and by column
ColMeans <- apply(M, 2, mean)
print(ColMeans)

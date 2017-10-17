SomeOperation <- function(v){
    if(sum(v) > 0){
        return(v * 100)
    }
    return(v)
}

M <- matrix(rnorm(100), 10, 10)

print(apply(M, 1, SomeOperation))

x <- 1:20  # a vector
y <- factor(rep(letters[1:5], each = 4)) # A factor of same legnthdefining groupls:
tapply(x, y, sum)


# import some data
attach(iris)
print(iris)

# use colMeans - better for dataframes
by(iris[,1:2], iris$Species, colMeans)
by(iris[,1:2], iris$Petal.Width, colMeans)

print(replicate(10, runif(5)))

M <- matrix(runif(1000), nrow = 1000, ncol = 1000)

SumAllElements <- function(M){
  Dimensions <- dim(M)
  Tot <- 0 
  for(i in 1:Dimensions[1]){
    for(j in 1:Dimensions[2]){
      Tot <- Tot + M[1, j]
    }
  }
  return(Tot)
}

# How long does my function take?! -- About 0.47 seconds
print(system.time(SumAllElements(M)))

# How long does R's SUM function takes? -- About 0.002 seconds
print(system.time(sum(M)))
